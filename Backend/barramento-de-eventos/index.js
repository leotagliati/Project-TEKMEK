const express = require('express')
const axios = require('axios')
const app = express()
app.use(express.json())

const services = {
    userLoginService: { baseUrl: 'http://localhost', port: 5315 },
}

const eventRoutes = {
    UserRegistered: [{ service: '', path: '' }], // tem que trocar o service por um existente que precise ouvir
    UserLogged: [{ service: '', path: '' }],

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
            console.log(`Event ${eventType} sent successfully`)
        } catch (err) {
            console.log('Error sending event: to all hearing MS:', err.message)
        }
    }
    else {
        console.log(`No MS hearing ${eventType} event`)
    }

    res.status(200).send({ status: 'Event processed successfully' })
})

const port = 5300
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------')
    console.log(`'Event Bus' running at port ${port}`)
    console.log('----------------------------------------------------')

})