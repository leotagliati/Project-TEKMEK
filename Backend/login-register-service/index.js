const express = require('express')
const axios = require('axios')
const app = express()
app.use(express.json())

const loginDB = {}
let id = 1
app.get('/login', (req, res) => {
    res.json(loginDB)
})


app.post('/login', (req, res) => {
    // 1. Get keyboard props
    const { username, password } = req.body
    const login = {
        id: id,
        username: username,
        password: password
    }
    loginDB[id] = login
    id++
    axios.post('http://localhost:5050/event', {
        type: 'LoginCreated',
        data: {
            id: login.id,
            username: login.username,
            password: login.password
        }
    })
        .then(resAxios => {
            console.log('Event sent sucessfully')
        })
        .catch(err => {
            console.log('Error sending event:', err.message)
        })
    res.status(201).json(login)

})

const port = 5315
app.listen(port, () => {
    console.clear()
    console.log('----------------------------------------------------')
    console.log(`'Login service' running at port ${port}.`)
    console.log('----------------------------------------------------')
})