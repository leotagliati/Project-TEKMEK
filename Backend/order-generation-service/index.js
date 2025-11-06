require('dotenv').config();
const express = require('express');
const cors = require('cors');

const { Pool } = require('pg');

const app = express();
app.use(express.json());
app.use(cors());

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

// GET listar todos os pedidos de um usuário
app.get('/api/user/orders', async (req, res) => {
    try {
        const userId = req.query.userId

        if (!userId) {
            return res.status(400).json({ error: 'userId é obrigatório.' });
        }

        // Busca os pedidos e seus itens, com informações dos produtos locais
        const result = await pool.query(
            `SELECT 
                o.id AS order_id,
                o.status,
                o.valor_total,
                o.created_at,
                oi.product_id,
                oi.quantity,
                oi.price,
                op.name AS product_name,
                op.image_url AS product_image
             FROM orders_tb o
             JOIN order_items_tb oi ON o.id = oi.order_id
             JOIN order_products_tb op ON oi.product_id = op.product_id
             WHERE o.user_id = $1
             ORDER BY o.created_at DESC`,
            [userId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'Nenhum pedido encontrado para este usuário.' });
        }

        // Agrupa os itens por pedido
        const ordersMap = {};

        result.rows.forEach(row => {
            if (!ordersMap[row.order_id]) {
                ordersMap[row.order_id] = {
                    id: row.order_id,
                    status: row.status,
                    totalPrice: parseFloat(row.valor_total),
                    createdAt: row.created_at,
                    items: []
                };
            }

            ordersMap[row.order_id].items.push({
                productId: row.product_id,
                name: row.product_name,
                imageUrl: row.product_image,
                quantity: row.quantity,
                price: parseFloat(row.price)
            });
        });

        const orders = Object.values(ordersMap);

        return res.status(200).json(orders);
    } catch (error) {
        console.error('Erro ao buscar pedidos:', error);
        return res.status(500).json({ error: 'Erro interno ao buscar pedidos.' });
    }
});


// Rota que escuta eventos do barramento
app.post('/event', async (req, res) => {
    try {
        const { type, data } = req.body;

        // Escuta apenas eventos de checkout
        if (type === 'CartCheckoutInitiated') {
            const { userId, items } = data;

            if (!userId || !items || items.length === 0) {
                return res.status(400).json({ error: 'Dados inválidos no evento.' });
            }

            // Calcula o valor total do pedido
            const totalValue = items.reduce((acc, item) => acc + (item.price * item.quantity), 0);

            // Cria novo pedido
            const newOrder = await pool.query(
                `INSERT INTO orders_tb (user_id, status, valor_total, created_at, updated_at)
                 VALUES ($1, $2, $3, NOW(), NOW())
                 RETURNING id`,
                [userId, 'PENDING', totalValue]
            );

            const orderId = newOrder.rows[0].id;
            console.log(`🧾 Pedido #${orderId} criado para o usuário ${userId}`);

            // Insere os itens do pedido
            for (const item of items) {
                await pool.query(
                    `INSERT INTO order_items_tb (order_id, product_id, quantity, price)
                     VALUES ($1, $2, $3, $4)`,
                    [orderId, item.productId, item.quantity, item.price]
                );
            }

            console.log(`📦 Itens adicionados ao pedido #${orderId}.`);
            return res.status(200).json({ message: `Pedido #${orderId} criado com sucesso.` });
        }

        // Ignora outros tipos de evento
        return res.status(200).json({ message: `Evento '${type}' ignorado.` });

    } catch (error) {
        console.error('Erro ao processar evento:', error);
        return res.status(500).json({ error: 'Erro interno ao processar evento.' });
    }
});

const port = process.env.MS_PORT;
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------');
    console.log(`'Order Service' rodando na porta ${port}.`);
    console.log('----------------------------------------------------');
});
