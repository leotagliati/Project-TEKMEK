const express = require('express')
const axios = require('axios')
const cors = require('cors')
const app = express()
app.use(express.json())
app.use(cors())

app.post('/checkout', async (req, res) => {
    const { userId, items } = req.body

    if (!userId || !Array.isArray(items) || items.length === 0) {
        return res.status(400).json({ message: 'Dados incompletos para checkout.' })
    }

    const event = {
        type: 'CartCheckoutInitiated',
        data: {
            userId,
            items
        }
    }

    try {
        await axios.post('http://localhost:5300/event', event);
        res.status(200).json({ message: 'Checkout iniciado com sucesso.' })
        console.log(`Checkout iniciado para o usuário ${userId} com os itens:`, items)
    }
    catch (e) {
        console.error('Erro ao enviar evento para o barramento:', e.message)
        res.status(500).json({ message: 'Erro interno ao processar o checkout.' })
    }
})

app.post('/event', (req, res) => {
    const event = req.body;
    if (event.type === 'OrderCreated') {
        const { orderId, userId, status } = event.data;
        console.log(`Pedido ${orderId} criado com sucesso para o usuário ${userId}. Status: ${status}`);
    }
    res.sendStatus(200)
})

const PORT = 5316
app.listen(PORT, () => {
    console.clear()
    console.log('--------------------------------------------')
    console.log(`Cart Service escutando na porta ${PORT}`)
    console.log('--------------------------------------------')
})
