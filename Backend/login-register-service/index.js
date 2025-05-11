const express = require('express')
const axios = require('axios')
const cors = require('cors')
const app = express()
app.use(express.json())
app.use(cors())

const loginDB = {}
let id = 1
app.get('/login', (req, res) => {
    res.json(loginDB)
})


app.post('/register', (req, res) => {
    const { username, password } = req.body

    if (!username || !password) {
        return res.status(400).json({ error: 'Username and/or password invalid' })
    }
    const usernameExists = Object.values(loginDB).some(user => user.username === username);

    if (usernameExists) {
        return res.status(409).json({ error: 'Esse nome de usuário já está em uso.' })
    }

    const login = {
        id: id,
        username: username,
        password: password
    }
    loginDB[id] = login
    id++
    axios.post('http://localhost:5300/event', {
        type: 'UserRegistered',
        data: {
            id: login.id,
            username: login.username,
            // password: login.password // estou expondo dados sensiveis no barramento?
        }
    })
        .then(resAxios => {
            console.log('Event sent sucessfully')
        })
        .catch(err => {
            console.log('Error sending event: ', err.message)
        })
    res.status(201).json(login)

})

app.post('/login', (req, res) => {
    const { username, password } = req.body

    if (!username || !password) {
        return res.status(400).json({ error: 'Username and/or password invalid' })
    }

    const user = Object.values(loginDB).find(user => user.username === username);

    if (!user) {
        return res.status(404).json({ error: 'Username not found' });
    }

    if (user.password !== password) {
        return res.status(401).json({ error: 'Wrong pass' }); // 401 Unauthorized
    }


    axios.post('http://localhost:5300/event', {
        type: 'UserLogged',
        data: {
            username: username
            // password: login.password // estou expondo dados sensiveis no barramento?
        }
    })
        .then(resAxios => {
            console.log('Event sent sucessfully')
        })
        .catch(err => {
            console.log('Error sending event: ', err.message)
        })

    res.status(200).json({ message: 'Success logging', user })
})

const port = 5315
app.listen(port, () => {
    console.clear()
    console.log('----------------------------------------------------')
    console.log(`'Login service' running at port ${port}.`)
    console.log('----------------------------------------------------')
})