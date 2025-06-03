const express = require('express');
const axios = require('axios');
const app = express();
app.use(express.json());

const services = {
    userLoginService: { baseUrl: 'http://localhost', port: 5315 },

    cartService: { baseUrl: 'http://localhost', port: 5316 },
    orderGenerationService: { baseUrl: 'http://localhost', port: 5317 },
    searchProductsService: { baseUrl: 'http://localhost', port: 5320 },
};

const eventRoutes = {
    UserRegistered: [{ service: 'userLoginService', path: '/handle-register' }],
    UserLogged: [{ service: 'userLoginService', path: '/handle-login' }],
}


    CartCheckoutInitiated: [
        { service: 'orderGenerationService', path: '/handle-order' }
    ],

    OrderCreated: [
        { service: 'cartService', path: '/order-confirmation' }
    ],
};

app.post('/event', async (req, res) => {
    const event = req.body;
    const eventType = event.type;

    if (eventRoutes[eventType]) {
        try {
            const promises = eventRoutes[eventType].map(({ service, path }) => {
                const { baseUrl, port } = services[service];
                const url = `${baseUrl}:${port}${path}`;
                return axios.post(url, event);
            });

            await Promise.all(promises);

            console.log(`Evento '${eventType}' enviado com sucesso para os microsserviços ouvintes.`);
        } 
        catch (err) {
            console.error(`Erro ao enviar evento '${eventType}':`, err.message);

        }
    } 
    else {
        console.log(`Nenhum microsserviço ouvindo o evento '${eventType}'`);
    }
    res.status(200).send({ status: 'Evento processado com sucesso.' });
});

const port = 5300
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------')
    console.log(`'Event Bus' running at port ${port}`)
    console.log('----------------------------------------------------')

})