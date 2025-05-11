const express = require('express')
const axios = require('axios')
const app = express()
app.use(express.json())

const services = {
    userLoginService: { baseUrl: 'http://localhost', port: 5315 },
}

const eventRoutes = {
    UserRegistered: [''],
    UserLogged: [''],

}

app.post('/event', async (req, res) => {
    const event = req.body
    const eventType = event.type

    if (eventRoutes[eventType]) {
        try {
            const promises = eventRoutes[eventType].map(({ service, path }) => {
                const { baseUrl, port } = services[service]
                const url = `${baseUrl}:${port}${path}`
                return axios.post(url, event)
            })
            await Promise.all(promises)
            console.log(`Evento ${eventType} enviado com sucesso`)
        } catch (error) {
            console.log('Erro ao enviar evento para o(s) MS:', err.message)
        }
    }
    else {
        console.log(`Nenhum servico registrado para o evento ${eventType}`)
    }

    res.status(200).send({ status: 'Evento processado com sucesso' })
})

const port = 5300
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------')
    console.log(`'Barramento de eventos' at port ${port}`)
    console.log('----------------------------------------------------')

})