const express = require('express');
const axios = require('axios');
const app = express();
app.use(express.json());

const services = {
    userLoginService: { baseUrl: 'http://localhost', port: 5315 },

    cartService: { baseUrl: 'http://localhost', port: 5316 },
    orderGenerationService: { baseUrl: 'http://localhost', port: 5317 },
    searchProductsService: { baseUrl: 'http://localhost', port: 5240 },
    adminProductManager: { baseUrl: 'http://localhost', port: 4321 }
};

const eventRoutes = {
    // Registrar os servicos que ouvem os eventos

    UserRegistered: [{ service: 'userLoginService' }],
    UserLogged: [{ service: 'userLoginService' }],

    CartCheckoutInitiated: [{ service: 'orderGenerationService' }],
    OrderCreated: [],

    ProductSearched: [{ service: 'searchProductsService' }],

    ProductCreated: [{ service: 'searchProductsService'}],
    ProductDeleted: [{ service: 'searchProductsService' }],
    ProductsFetched: [],
};

app.post('/event', async (req, res) => {
    const event = req.body;
    const eventType = event.type;

    if (eventRoutes[eventType]) {
        console.log(`Microsserviços ouvindo o evento '${eventType}':`, eventRoutes[eventType]);
        try {
            const promises = eventRoutes[eventType].map(({ service }) => {
                const { baseUrl, port } = services[service];
                const url = `${baseUrl}:${port}/event`;
                // console.log(`Enviando evento '${eventType}' para o microsserviço: ${service} na rota: ${url}`);
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