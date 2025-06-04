const express = require('express')
const axios = require('axios')
const cors = require('cors')
const { Pool } = require('pg')
const bcrypt = require('bcrypt')

const app = express()
app.use(express.json())
app.use(cors())
const saltRounds = 10

// Configuração do PostgreSQL
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'login_db',
  password: 'imtdb',
  port: 5432
})

// Teste de conexão + SELECT simples
pool.connect((err, client, release) => {
  if (err) {
    return console.error('Erro ao conectar:', err.stack)
  }

  console.log('Conectado ao PostgreSQL com sucesso')

  client.query('SELECT * FROM login_tb', (err, result) => {
    release()
    if (err) {
      return console.error('Erro ao fazer SELECT:', err.message)
    }
    console.log('Resultado do SELECT:', result.rows)
  })
})

const registerUser = (username, password) => {
  return new Promise(async (resolve, reject) => {
    if (!username || !password) {
      return reject({ code: 400, error: 'Username and/or password invalid' })
    }

    try {
      const { rows } = await pool.query('SELECT username FROM login_tb WHERE username = $1', [username])
      if (rows.length !== 0) {
        return reject({ code: 409, error: 'Could not register user' })
      }

      const hashedPassword = await bcrypt.hash(password, saltRounds)
      await pool.query('INSERT INTO login_tb (username, user_pass) VALUES ($1, $2)', [username, hashedPassword])

      resolve({ username })
    } catch (err) {
      console.error(err)
      reject({ code: 500, error: 'Erro ao registrar usuário' })
    }
  })
}

const validateLogin = (username, password) => {
  return new Promise(async (resolve, reject) => {
    if (!username || !password) {
      return reject({ code: 400, error: 'Username and/or password invalid' })
    }

    try {
      const { rows } = await pool.query('SELECT * FROM login_tb WHERE username = $1', [username])
      if (rows.length === 0) {
        return reject({ code: 401, error: 'Username and/or password invalid' })
      }

      const user = rows[0]
      const isPasswordValid = await bcrypt.compare(password, user.user_pass)

      if (!isPasswordValid) {
        return reject({ code: 401, error: 'Username and/or password invalid' })
      }

      resolve({ username: user.username, accountId: user.idlogin })
    } catch (err) {
      console.error(err)
      reject({ code: 500, error: 'Internal server error' })
    }
  })
}

app.post('/register', (req, res) => {
  const { username, password } = req.body

  registerUser(username, password)
    .then(user => {
      axios.post('http://localhost:5300/event', {
        type: 'UserRegistered',
        data: { username: user.username }
      }).then(() => {
        console.log('Event sent successfully')
      }).catch(err => {
        console.log('Error sending event:', err.message)
      })

      res.status(201).json(user)
    })
    .catch(err => {
      res.status(err.code || 500).json({ error: err.error || 'Unknown error' })
    })
})

app.post('/login', (req, res) => {
  const { username, password } = req.body

  validateLogin(username, password)
    .then(user => {
      axios.post('http://localhost:5300/event', {
        type: 'UserLogged',
        data: {
          username: user.username,
          accountId: user.accountId
        }
      }).then(() => {
        console.log('Event sent successfully')
      }).catch(err => {
        console.log('Error sending event:', err.message)
      })

      res.status(201).json(user)
    })
    .catch(err => {
      res.status(err.code || 500).json({ error: err.error || 'Unknown error' })
    })
})

const port = 5315
app.listen(port, () => {
  console.clear()
  console.log('----------------------------------------------------')
  console.log(`'Login service' running at port ${port}.`)
  console.log('----------------------------------------------------')
})
