const express = require('express')
const axios = require('axios')
const app = express()
app.use(express.json())

app.post('/event', async (req, res) => {
    const event = req.body
    try {
        await axios.post('http://localhost:5050/event', event)
    }
    catch (err) {
        console.log('Erro ao enviar evento para o ms :', err.message)
    }
    res.end()
})

const port = 5300
app.listen(port, () => {
    console.log(`'Barramento de eventos' at port ${port}`)
})