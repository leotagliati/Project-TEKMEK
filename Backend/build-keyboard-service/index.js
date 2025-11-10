const express = require('express')
const axios = require('axios')
const app = express()
app.use(express.json())

/*
    1: {
        "id": 1,
        "name": "Teclado mecânico",
        "components": [
            {
                "id": 1,
                "switchType": "Switch mecânico blue",
                "pricePerUnit": 0.50
            },
            {
                "id": 2,
                "pcbBoard": "pcb 70%",
                "price": 5.00
            },
            {
                "id": 3,
                "case": "case white 70%",
                "price": 10.00
            },
            {
                "id": 4,
                "keycaps": "keycaps white",
                "pricePerUnit": 2.00
            },
            {
                "id": 5,
                "stabilizers": "stabilizers",
                "price": 1.00
            }
        ],
    },
    2: {
        ...
    }
*/

const keyBoardDB = {}
let id = 1
app.get('/buildkeyboardservice', (req, res) => {
    res.json(keyBoardDB)
})


app.post('/buildkeyboardservice', (req, res) => {
    // 1. Get keyboard props
    const { name, components } = req.body
    const keyboard = {
        id: id,
        name: name,
        components: components || []
    }
    keyBoardDB[id] = keyboard
    id++
    axios.post('http://localhost:5050/event', {
        type: 'KeyboardCreated',
        data: {
            id: keyboard.id,
            name: keyboard.name,
            components: keyboard.components
        }
    })
        .then(resAxios => {
            console.log('Event sent sucessfully')
        })
        .catch(err => {
            console.log('Error sending event:', err.message)
        })
    res.status(201).json(keyboard)

})

const port = 5310
app.listen(port, () => {
    console.clear()
    console.log('----------------------------------------------------')
    console.log(`'Keyboard building service' running at port ${port}.`)
    console.log('----------------------------------------------------')
})
