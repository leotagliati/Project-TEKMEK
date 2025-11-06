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

app.get('/orders/:userId', async (req, res) => {
    try {
        const { userId } = req.params;

        // Busca o pedido pendente do usuário
        const orderResult = await pool.query(
            'SELECT * FROM orders WHERE user_id = $1',
            [userId]
        );

        if (orderResult.rows.length === 0) {
            return res.status(404).json({ message: 'Nenhum pedido pendente encontrado.' });
        }

        const order = orderResult.rows[0];

        // Busca os itens do pedido
        const itemsResult = await pool.query(
            'SELECT * FROM order_items WHERE order_id = $1',
            [order.id]
        );

        order.items = itemsResult.rows;

        return res.status(200).json(order);
    } catch (error) {
        console.error('Erro ao buscar pedido:', error);
        return res.status(500).json({ error: 'Erro interno ao buscar pedido.' });
    }
});

app.post('/event', async (req, res) => {
    try {
        const eventType = req.body.type;

        // Apenas tratamos eventos de checkout do carrinho
        if (eventType === 'CartCheckoutInitiated') {
            const { userId, items } = req.body.data;

            // Verifica se já existe pedido pendente do usuário
            const existingOrder = await pool.query(
                'SELECT * FROM orders WHERE user_id = $1 AND status = $2',
                [userId, 'PENDING']
            );

            let orderId;
            let totalPrice = 0;

            // Calcula o preço total dos itens recebidos
            for (const item of items) {
                totalPrice += item.price * item.quantity;
            }

            if (existingOrder.rows.length > 0) {
                // Atualiza o pedido existente
                orderId = existingOrder.rows[0].id;

                console.log(`Pedido existente #${orderId} encontrado para o usuário ${userId}. Atualizando itens.`);

                // Atualiza valor total
                await pool.query(
                    'UPDATE orders SET valor_total = $1, updated_at = NOW() WHERE id = $2',
                    [totalPrice, orderId]
                );

                // Remove itens antigos e insere os novos
                await pool.query('DELETE FROM order_items WHERE order_id = $1', [orderId]);

                for (const item of items) {
                    await pool.query(
                        'INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ($1, $2, $3, $4)',
                        [orderId, item.productId, item.quantity, item.price]
                    );
                }

                console.log(`Pedido #${orderId} atualizado com sucesso.`);

            } else {
                // Cria novo pedido
                const newOrder = await pool.query(
                    'INSERT INTO orders (user_id, status, valor_total) VALUES ($1, $2, $3) RETURNING id',
                    [userId, 'PENDING', totalPrice]
                );

                orderId = newOrder.rows[0].id;

                console.log(`Criando novo pedido #${orderId} para o usuário ${userId}.`);

                for (const item of items) {
                    await pool.query(
                        'INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ($1, $2, $3, $4)',
                        [orderId, item.productId, item.quantity, item.price]
                    );
                }

                console.log(`Pedido #${orderId} criado com sucesso.`);
            }

            return res.status(200).send({ message: `Pedido #${orderId} processado com sucesso.` });
        }

        // Evento não tratado
        return res.status(200).send({ message: `Evento ${eventType} ignorado.` });

    } catch (error) {
        console.error('Erro ao processar evento:', error);
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
