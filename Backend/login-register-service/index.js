const express = require('express')
const axios = require('axios')
const cors = require('cors')
const mysql = require('mysql2')
const bcrypt = require('bcrypt')

const app = express()
app.use(express.json())
app.use(cors())
const saltRounds = 10

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'imtdb',
})

connection.connect(err => {
    if (err) {
        return console.error('Erro ao conectar:', err.message)
    }
    console.log('Conectado ao MySQL com sucesso')

    // TESTE: SELECT simples
    connection.query('SELECT * FROM login_db.login', (err, results) => {
        if (err) {
            return console.error('Erro ao fazer SELECT:', err.message)
        }
        console.log('Resultado do SELECT:', results)
    })
})
const registerUser = (username, password) => {
  return new Promise((resolve, reject) => {
    if (!username || !password) {
      return reject({ code: 400, error: 'Username and/or password invalid' })
    }

    connection.query(
      'SELECT username FROM login_db.login WHERE username = ?',
      [username],
      async (err, results) => {
        if (err) return reject({ code: 500, error: 'Internal server error' })

        if (results.length !== 0) {
          // Mensagem genérica por segurança
          return reject({ code: 409, error: 'Could not register user' })
        }

        try {
          // Aguarda o hash ser gerado
          const hashedPassword = await bcrypt.hash(password, saltRounds)
          console.log(hashedPassword)
          connection.query(
            'INSERT INTO login_db.login (username, password) VALUES (?, ?)',
            [username, hashedPassword],
            (err, results) => {
              if (err) return reject({ code: 500, error: 'Erro ao registrar usuário' })

              resolve({ username })
            }
          );
        } catch (hashError) {
          reject({ code: 500, error: 'Erro interno do servidor.' })
        }
      }
    );
  });
}
const validateLogin = (username, password) => {
  return new Promise((resolve, reject) => {
    if (!username || !password) {
      return reject({ code: 400, error: 'Username and/or password invalid' })
    }

    connection.query(
      'SELECT * FROM login_db.login WHERE username = ?',
      [username],
      async (err, results) => {
        if (err) return reject({ code: 500, error: 'Internal server error' })

        if (results.length === 0) {
          return reject({ code: 401, error: 'Username and/or password invalid' })
        }

        const user = results[0];

        try {
          const isPasswordValid = await bcrypt.compare(password, user.password)

          if (!isPasswordValid) {
            return reject({ code: 401, error: 'Username and/or password invalid' })
          }

          resolve({ username })
        } catch (compareError) {
          reject({ code: 500, error: 'Internal server error' })
        }
      }
    )
  })
}


app.post('/register', (req, res) => {
    const { username, password } = req.body;

    registerUser(username, password)
        .then(user => {
            axios.post('http://localhost:5300/event', {
                type: 'UserRegistered',
                data: { username: user.username }
            }).then(() => {
                console.log('Event sent successfully')
            }).catch(err => {
                console.log('Error sending event:', err.message)
            });

            res.status(201).json(user);
        })
        .catch(err => {
            res.status(err.code || 500).json({ error: err.error || 'Unknown error' })
        });
});

app.post('/login', (req, res) => {
    const { username, password } = req.body

    validateLogin(username, password)
        .then(user => {
            axios.post('http://localhost:5300/event', {
                type: 'UserLogged',
                data: { username: user.username }
            }).then(() => {
                console.log('Event sent successfully');
            }).catch(err => {
                console.log('Error sending event:', err.message);
            });

            res.status(201).json(user);
        })
        .catch(err => {
            res.status(err.code || 500).json({ error: err.error || 'Unknown error' });
        });
});

const port = 5315
app.listen(port, () => {
    console.clear()
    console.log('----------------------------------------------------')
    console.log(`'Login service' running at port ${port}.`)
    console.log('----------------------------------------------------')
})