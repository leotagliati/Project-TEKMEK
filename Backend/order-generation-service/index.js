require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const { v4: uuidv4 } = require('uuid');
const axios = require('axios');

const app = express();
app.use(express.json());

// Conexão com PostgreSQL
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT
});
pool.connect((err, client, release) => {
    if (err) {
        console.error('Erro ao conectar ao PostgreSQL:', err);
        process.exit(1);
    }
    console.log('Conectado ao PostgreSQL com sucesso!');
    release();
}
);

app.post('/handle-order', async (req, res) => {
    const { userId, items } = req.body.data || {};

    if (!userId || !items || !Array.isArray(items)) {
        return res.status(400).send({ message: 'Dados inválidos para criação de pedido' });
    }

    const orderId = uuidv4();
    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        await client.query(
            'INSERT INTO orders (order_id, user_id) VALUES ($1, $2)',
            [orderId, userId]
        );

        for (const item of items) {
            await client.query(
                'INSERT INTO order_items (order_id, product_id, quantity) VALUES ($1, $2, $3)',
                [orderId, item.productId, item.quantity]
            );
        }

        await client.query('COMMIT');

        console.log(`Pedido ${orderId} criado com sucesso.`);

        await axios.post('http://localhost:5300/event', {
            type: 'OrderCreated',
            data: {
                orderId,
                userId,
                status: 'created',
            }
        });

        res.status(201).send({ message: 'Pedido criado com sucesso.', orderId });

    } catch (err) {
        await client.query('ROLLBACK');
        console.error('Erro ao criar pedido:', err.message);
        res.status(500).send({ message: 'Erro interno ao criar o pedido.' });
    } finally {
        client.release();
    }
});

const port = 5317;
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------');
    console.log(`'Order Service' rodando na porta ${port}.`);
    console.log('----------------------------------------------------');
});
