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

app.post('/event', async (req, res) => {
    const eventType = req.body.type;

    if (eventType === 'CartCheckoutInitiated') {
        const { userId, items } = req.body.data;
        // procura se o usuário ja possui um pedido em andamento
        const existingOrder = await pool.query(
            'SELECT * FROM orders_tb WHERE user_id = $1 AND status = $2',
            [userId, 'PENDING']
        );
        if (existingOrder.rows.length > 0) {
            // Se já existe um pedido pendente, ele so adiciona os itens ao pedido existente
            console.log(`Pedido existente encontrado para o usuário ${userId}. Adicionando itens ao pedido existente.`);
            const orderId = existingOrder.rows[0].id;
            let totalPrice = parseFloat(existingOrder.rows[0].total);
            // pega todos os produtos do carrinho e soma o preco
            for (const item of items) {
                const product = await pool.query(
                    'SELECT price FROM known_products_tb WHERE id = $1',
                    [item.productId]
                );
                if (product.rows.length > 0) {
                    totalPrice += parseFloat(product.rows[0].price) * item.quantity;
                }
            }
            // Atualiza o total do pedido existente
            await pool.query(
                'UPDATE orders_tb SET total = $1 WHERE id = $2',
                [totalPrice, orderId]
            );
            // Adiciona os itens ao pedido existente
            for (const item of items) {
                await pool.query(
                    'INSERT INTO order_items_tb (order_id, product_id, quantity) VALUES ($1, $2, $3)',
                    [orderId, item.productId, item.quantity]
                );
            }
            console.log(`Itens adicionados ao pedido existente ${orderId} para o usuário ${userId}.`);
        }
        else {
            // Cria um novo pedido
            console.log(`Criando um novo pedido para o usuário ${userId}.`);
            const orderId = uuidv4();
            // pega todos os produtos do carrinho e soma o preco
            let totalPrice = 0;
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
            console.log(`Pedido ${orderId} criado com sucesso para o usuário ${userId}.`);
        }



    } else {
        // Tipo de evento não tratado
        res.status(200).send({ message: `Evento ${eventType} ignorado.` });
    }
});

const port = process.env.MS_PORT;
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------');
    console.log(`'Order Service' rodando na porta ${port}.`);
    console.log('----------------------------------------------------');
});
