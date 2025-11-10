const express = require('express')
const axios = require('axios')
const app = express()
app.use(express.json())

const services = {
<<<<<<< HEAD
    userLoginService: { port: process.env.USER_LOGIN_SERVICE_PORT },
    cartService: { port: process.env.CART_SERVICE_PORT },
    orderGenerationService: { port: process.env.ORDER_GENERATION_SERVICE_PORT },
    productsService: { port: process.env.PRODUCTS_SERVICE_PORT },
};

const eventRoutes = {
    // Registrar os servicos que ouvem os eventos
    // nome_evento : [{ service: nome_servico }]

    CartCheckoutInitiated: [
        { service: 'orderGenerationService' }
    ],

    ProductCreated: [
        { service: 'cartService' }, { service: 'orderGenerationService' }
    ],

    ProductUpdated: [
        { service: 'cartService' }, { service: 'orderGenerationService' }
    ],

    ProductRemoved: [
        { service: 'cartService' }, { service: 'orderGenerationService' }
    ]
};
=======
    userLoginService: { baseUrl: 'http://localhost', port: 5315 },
}

const eventRoutes = {
    UserRegistered: [{ service: '', path: '' }], // tem que trocar o service por um existente que precise ouvir
    UserLogged: [{ service: '', path: '' }],

}
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc

app.post('/event', async (req, res) => {
    const event = req.body
    const eventType = event.type

    if (eventRoutes[eventType]) {
        try {
<<<<<<< HEAD
            const promises = eventRoutes[eventType].map(({ service }) => {
                const { port } = services[service];
                const url = `http://localhost:${port}/event`;
                console.log(`Enviando evento '${eventType}' para o microsserviço: ${service} na rota: ${url}`);
                return axios.post(url, event);
            });

            await Promise.all(promises);

            console.log(`Evento '${eventType}' enviado com sucesso para os microsserviços ouvintes.`);
        }
        catch (err) {
            console.error(`Erro ao enviar evento '${eventType}':`, err.message);

=======
            const promises = eventRoutes[eventType].map(({ service, path }) => {
                const { baseUrl, port } = services[service]
                const url = `${baseUrl}:${port}${path}`
                return axios.post(url, event)
            })
            await Promise.all(promises)
            console.log(`Event ${eventType} sent successfully`)
        } catch (err) {
            console.log('Error sending event to all hearing MS:', err.message)
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc
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