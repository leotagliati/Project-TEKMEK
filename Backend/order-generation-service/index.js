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
});

app.post('/event', async (req, res) => {
    try {
        const eventType = req.body.type;

        if (eventType === 'CartCheckoutInitiated') {
            const { userId, items } = req.body.data;

            // Verifica se já há um pedido pendente para o usuário
            const existingOrder = await pool.query(
                'SELECT * FROM orders_tb WHERE user_id = $1 AND status = $2',
                [userId, 'PENDING']
            );

            if (existingOrder.rows.length > 0) {
                const orderId = existingOrder.rows[0].id;
                let totalPrice = parseFloat(existingOrder.rows[0].total);

                console.log(`Pedido existente encontrado para o usuário ${userId}. Adicionando itens.`);

                for (const item of items) {
                    const product = await pool.query(
                        'SELECT price FROM known_products_tb WHERE id = $1',
                        [item.productId]
                    );
                    if (product.rows.length > 0) {
                        totalPrice += parseFloat(product.rows[0].price) * item.quantity;
                    }
                }

                await pool.query(
                    'UPDATE orders_tb SET total = $1 WHERE id = $2',
                    [totalPrice, orderId]
                );

                for (const item of items) {
                    await pool.query(
                        'INSERT INTO order_items_tb (order_id, product_id, quantity) VALUES ($1, $2, $3)',
                        [orderId, item.productId, item.quantity]
                    );
                }

                console.log(`Itens adicionados ao pedido ${orderId}.`);

            } else {
                // Cria um novo pedido
                const orderId = uuidv4();
                let totalPrice = 0;

                console.log(`Criando novo pedido para o usuário ${userId}.`);

                for (const item of items) {
                    const product = await pool.query(
                        'SELECT price FROM known_products_tb WHERE id = $1',
                        [item.productId]
                    );
                    if (product.rows.length > 0) {
                        totalPrice += parseFloat(product.rows[0].price) * item.quantity;
                    }
                }

                await pool.query(
                    'INSERT INTO orders_tb (id, user_id, status, total) VALUES ($1, $2, $3, $4)',
                    [orderId, userId, 'PENDING', totalPrice]
                );

                for (const item of items) {
                    await pool.query(
                        'INSERT INTO order_items_tb (order_id, product_id, quantity) VALUES ($1, $2, $3)',
                        [orderId, item.productId, item.quantity]
                    );
                }

                console.log(`Pedido ${orderId} criado com sucesso.`);
            }

            return res.status(200).send({ message: 'Pedido processado com sucesso.' });
        }

        // Evento não tratado
        return res.status(200).send({ message: `Evento ${eventType} ignorado.` });

    } catch (error) {
        console.error('Erro ao processar evento:', error.message);
        return res.status(500).send({ error: 'Erro interno ao processar o evento.' });
    }
});

const port = process.env.MS_PORT;
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------');
    console.log(`'Order Service' rodando na porta ${port}.`);
    console.log('----------------------------------------------------');
});
