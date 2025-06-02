const express = require('express')
const axios = require('axios')
const app = express()
app.use(express.json())

const services = {
    userLoginService: { baseUrl: 'http://localhost', port: 5315 },
    searchProductsService: { baseUrl: 'http://localhost', port: 5320 },
}

const eventRoutes = {
    UserRegistered: [{ service: services.searchProductsService, path: `${services.searchProductsService.baseUrl}${services.searchProductsService.port}` }],
    UserLogged: [{ service: services.searchProductsService, path: `${services.searchProductsService.baseUrl}${services.searchProductsService.port}` }],

}

app.post('/event', async (req, res) => {
    const event = req.body
    const eventType = event.type

    if (eventRoutes[eventType]) {
        try {
            const promises = eventRoutes[eventType].map(({ service, path }) => {
                // const { baseUrl, port } = services[service]
                const url = `${service.baseUrl}:${service.port}`
                console.log(`Sending event ${eventType} to ${url}`)
                return axios.post(url, event)
            })
            await Promise.all(promises)
            console.log(`Event ${eventType} sent successfully`)
        } catch (err) {
            console.log('Error sending event to all hearing MS:', err.message)
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