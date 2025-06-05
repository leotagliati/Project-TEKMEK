// 1) Carrega variáveis de ambiente do .env
require('dotenv').config();

const express = require('express');
const axios = require('axios');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');

const app = express();
app.use(express.json());
app.use(cors());
const saltRounds = 10;

// 2) Configuração do PostgreSQL usando variáveis de ambiente
const pool = new Pool({
  user:     process.env.BD_USER,
  host:     process.env.BD_HOST,
  database: process.env.BD_DATABASE,
  password: process.env.BD_PASSWORD,
  port:     parseInt(process.env.BD_PORT, 10)
});

// 3) Teste de conexão + SELECT simples
pool.connect((err, client, release) => {
  if (err) {
    return console.error('Erro ao conectar:', err.stack);
  }

  console.log('Conectado ao PostgreSQL com sucesso');

  client.query('SELECT * FROM login_tb', (err, result) => {
    release();
    if (err) {
      return console.error('Erro ao fazer SELECT:', err.message);
    }
    console.log('Resultado do SELECT:', result.rows);
  });
});

const registerUser = (username, password, token) => {
  return new Promise(async (resolve, reject) => {
    if (!username || !password) {
      return reject({ code: 400, error: 'Username and/or password invalid' });
    }

    try {
      // Verifica se já existe usuário com esse username
      const { rows } = await pool.query(
        'SELECT username FROM login_tb WHERE username = $1',
        [username]
      );
      if (rows.length !== 0) {
        return reject({ code: 409, error: 'Could not register user: username already exists' });
      }
      
      // Criptografa a senha
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      
      if(token === undefined || token === null || token === ''){
        isAdmin = 'false';
      }
      else if(token === process.env.ADMIN_TOKEN){
        isAdmin = 'true';
      }
      else{
        return reject({ code: 401, error: 'Invalid token' });
      }
     
      
      await pool.query(
        'INSERT INTO login_tb (username, user_pass, is_admin) VALUES ($1, $2, $3)',
        [username, hashedPassword, isAdmin]
      );

      resolve({ username , isAdmin });
    } catch (err) {
      console.error(err);
      reject({ code: 500, error: 'Erro ao registrar usuário' });
    }
  });
};

const validateLogin = (username, password) => {
  return new Promise(async (resolve, reject) => {
    if (!username || !password) {
      return reject({ code: 400, error: 'Username and/or password invalid' });
    }

    try {
      // Busca o usuário completo (incluindo is_admin)
      const { rows } = await pool.query(
        'SELECT username, user_pass, is_admin FROM login_tb WHERE username = $1',
        [username]
      );
      if (rows.length === 0) {
        return reject({ code: 401, error: 'Username and/or password invalid' });
      }

      const user = rows[0];
      const isPasswordValid = await bcrypt.compare(password, user.user_pass);

      if (!isPasswordValid) {
        return reject({ code: 401, error: 'Username and/or password invalid' });
      }

      resolve({ username: user.username, isAdmin: user.is_admin });
    } catch (err) {
      console.error(err);
      reject({ code: 500, error: 'Internal server error' });
    }
  });
};

app.post('/register', (req, res) => {
  const { username, password, token} = req.body;

  registerUser(username, password, token)
    .then(user => {
      // Envia evento de usuário registrado (opcional)
      axios.post('http://localhost:5300/event', {
        type: 'UserRegistered',
        data: { username: user.username }
      
      })
      .then(() => {
        console.log('Event sent successfully');
      })
      .catch(err => {
        console.log('Error sending event:', err.message);
      });

      res.status(201).json(user);
    })
    .catch(err => {
      res.status(err.code || 500).json({ error: err.error || 'Unknown error' });
    });
});

app.post('/login', (req, res) => {
  const { username, password } = req.body;

  validateLogin(username, password)
    .then(user => {
      // Envia evento de login (opcional)
      axios.post('http://localhost:5300/event', {
        type: 'UserLogged',
        data: {
          username: user.username,
          isAdmin: user.isAdmin
        }
      })
      .then(() => {
        console.log('Event sent successfully');
      })
      .catch(err => {
        console.log('Error sending event:', err.message);
      });

      // Retorna dados ao cliente (inclui isAdmin)
      res.status(200).json(user);
    })
    .catch(err => {
      res.status(err.code || 500).json({ error: err.error || 'Unknown error' });
    });
});

const port = 5315;
app.listen(port, () => {
  console.clear();
  console.log('----------------------------------------------------');
  console.log(`'Login service' running at port ${port}.`);
  console.log('----------------------------------------------------');
});
