require('dotenv').config();

const express = require('express');
const axios = require('axios');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const app = express();
app.use(express.json());
app.use(cors());
const saltRounds = 10;

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
});

const port = 5315;
app.listen(port, () => {
  console.clear();
  console.log('----------------------------------------------------');
  console.log(`'Serviço de Login' rodando na porta ${port}.`);
  console.log('----------------------------------------------------');
});