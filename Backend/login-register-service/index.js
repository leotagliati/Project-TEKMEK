const express = require('express')
const axios = require('axios')
const cors = require('cors')
const mysql = require('mysql2')

const app = express()
app.use(express.json())
app.use(cors())

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
            return reject({ code: 400, error: 'Username and/or password invalid' });
        }

        connection.query(
            'SELECT username FROM login_db.login WHERE username = ?',
            [username],
            (err, results) => {
                if (err) return reject({ code: 500, error: 'Internal server error' })

                if (results.length !== 0) {
                    return reject({ code: 409, error: 'Username already in use' })
                    // deveria so comentar que esta invalido por questoes de seguranca?
                }

                connection.query(
                    'INSERT INTO login_db.login (username, password) VALUES (?, ?)',
                    [username, password],
                    (err, results) => {
                        if (err) return reject({ code: 500, error: 'Erro ao registrar usuário' })

                        resolve({ username })
                    }
                )
            }
        )
    })
}
const validateLogin = (username, password) => {
    return new Promise((resolve, reject) => {
        if (!username || !password) {
            return reject({ code: 400, error: 'Username and/or password invalid' })
        }

        connection.query('SELECT * FROM login_db.login WHERE username = ?', username, (err, results) => {
            if (err) return reject({ code: 500, error: 'Internal server error' })

            if (results.length === 0) {
                return reject({ code: 401, error: 'Username and/or password invalid' });
            }
            const user = results[0]
            if (user.password !== password) {
                return reject({ code: 401, error: 'Username and/or password invalid' })
            }
            else {
                resolve({ username })
            }
        })

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