require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');

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

// ✅ Rota que escuta eventos do barramento
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
