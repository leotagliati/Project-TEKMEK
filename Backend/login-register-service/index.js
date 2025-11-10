<<<<<<< HEAD
require('dotenv').config();

const express = require('express');
const axios = require('axios');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
=======
const express = require('express')
const axios = require('axios')
const cors = require('cors')
const mysql = require('mysql2')
const bcrypt = require('bcrypt')

const app = express()
app.use(express.json())
app.use(cors())
const saltRounds = 10
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'imtdb',
})

<<<<<<< HEAD
class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
  }
}
class UnauthorizedError extends AppError {
  constructor(message) { super(message || 'Credenciais inválidas', 401); }
}
class ConflictError extends AppError {
  constructor(message) { super(message || 'Recurso já existe', 409); }
}
class BadRequestError extends AppError {
  constructor(message) { super(message || 'Requisição inválida', 400); }
}

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT
});

// Teste de conexão
pool.connect((err, client, release) => {
  if (err) {
    return console.error('Erro ao conectar ao PostgreSQL:', err.stack);
  }
  console.log('Conectado ao PostgreSQL com sucesso');
  release();
});

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) {
    return res.status(401).json({ error: 'Token não fornecido' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, userPayload) => {
    if (err) {
      return res.status(403).json({ error: 'Token inválido ou expirado' });
    }
    req.user = userPayload;
    next();
  });
};

const dispatchEvent = (type, data) => {
  (async () => {
    try {
      await axios.post('http://localhost:5300/event', { type, data });
      console.log(`Evento '${type}' enviado com sucesso.`);
    } catch (err) {
      console.error(`Erro ao enviar evento '${type}':`, err.message);
    }
  })();
};

const registerUser = async (username, password) => {
  if (!username || !password) {
    throw new BadRequestError('Usuário e/ou senha inválidos');
  }

  const { rows } = await pool.query(
    'SELECT username FROM login_tb WHERE username = $1',
    [username]
  );

  if (rows.length !== 0) {
    throw new ConflictError('Não foi possível registrar: usuário já existe');
  }

  const hashedPassword = await bcrypt.hash(password, saltRounds);
  const isAdmin = false;

  const { rows: inserted } = await pool.query(
    'INSERT INTO login_tb (username, user_pass, is_admin) VALUES ($1, $2, $3) RETURNING idlogin, username, is_admin',
    [username, hashedPassword, isAdmin]
  );

  return inserted[0];
};

const validateLogin = async (username, password) => {
  if (!username || !password) {
    throw new UnauthorizedError('Usuário e/ou senha inválidos');
  }

  const { rows } = await pool.query(
    'SELECT idlogin, username, user_pass, is_admin FROM login_tb WHERE username = $1',
    [username]
  );

  if (rows.length === 0) {
    throw new UnauthorizedError('Usuário e/ou senha inválidos');
  }

  const user = rows[0];
  const isPasswordValid = await bcrypt.compare(password, user.user_pass);

  if (!isPasswordValid) {
    throw new UnauthorizedError('Usuário e/ou senha inválidos');
  }

  return {
    idlogin: user.idlogin,
    username: user.username,
    isAdmin: user.is_admin
  };
};

app.post('/register', async (req, res) => {
  const { username, password } = req.body;

  try {
    const newUser = await registerUser(username, password);

    dispatchEvent('UserRegistered', { username: newUser.username });

    res.status(201).json(newUser);

  } catch (err) {
    res.status(err.statusCode || 500).json({ error: err.message || 'Erro interno do servidor' });
  }
});

app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await validateLogin(username, password);

    dispatchEvent('UserLogged', {
      username: user.username,
      isAdmin: user.isAdmin
    });

    const token = jwt.sign(
      { idlogin: user.idlogin, username: user.username, isAdmin: user.isAdmin },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.status(200).json({
      message: "Login bem-sucedido",
      token: token,
      user: user
    });

  } catch (err) {
    res.status(err.statusCode || 500).json({ error: err.message || 'Erro interno do servidor' });
  }
});

app.get('/auth/user', authenticateToken, async (req, res) => {
  try {
    const { rows } = await pool.query(
      'SELECT idlogin, username, is_admin FROM login_tb WHERE idlogin = $1',
      [req.user.idlogin]
    );

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Usuário não encontrado' });
    }

    const user = rows[0];
    res.status(200).json({
      idlogin: user.idlogin,
      username: user.username,
      isAdmin: user.is_admin
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.post('/recover-password', async (req, res) => {
  const { username } = req.body;

  try {
    if (username) {
      const { rows } = await pool.query(
        'SELECT idlogin FROM login_tb WHERE username = $1',
        [username]
      );

      if (rows.length > 0) {
        // Lógica de recuperação
      }
    }
    res.status(200).json({ message: 'Se uma conta com este e-mail existir, um link de recuperação foi enviado.' });

  } catch (err) {
    console.error(err);
    res.status(200).json({ message: 'Se uma conta com este e-mail existir, um link de recuperação foi enviado.' });
  }
=======
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
    )
  })
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
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc
});

const port = 5315
app.listen(port, () => {
<<<<<<< HEAD
  console.clear();
  console.log('----------------------------------------------------');
  console.log(`'Serviço de Login' rodando na porta ${port}.`);
  console.log('----------------------------------------------------');
});
=======
    console.clear()
    console.log('----------------------------------------------------')
    console.log(`'Login service' running at port ${port}.`)
    console.log('----------------------------------------------------')
})
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc
