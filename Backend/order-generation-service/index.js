const express = require('express');
const mysql = require('mysql2');
const { v4: uuidv4 } = require('uuid');
const app = express();
app.use(express.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'imtdb',
    database: 'order_service_db',
});

app.post('/handle-order', async (req, res) => {
    const { userId, items } = req.body.data || {};
    if (!userId || !items || !Array.isArray(items)) {
        return res.status(400).send({ message: 'Dados inválidos para criação de pedido' });
    }
    const orderId = uuidv4();

    try {
        db.beginTransaction((err) => {
            if (err) throw err;

            db.query('INSERT INTO orders (order_id, user_id) VALUES (?, ?)', [orderId, userId], (err) => {
                if (err) return db.rollback(() => { throw err; });

                const insertions = items.map(item => new Promise((resolve, reject) => {
                    db.query(
                        'INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)',
                        [orderId, item.productId, item.quantity],
                        (err) => err ? reject(err) : resolve()
                    );
                }));

                Promise.all(insertions)
                    .then(() => {
                        db.commit(async (err) => {
                            if (err) return db.rollback(() => { throw err; });
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
                        });
                    })
                    .catch((err) => db.rollback(() => { throw err; }));
            });
        });
    }
    catch (err) {
        console.error('Erro ao criar pedido:', err.message);
        res.status(500).send({ message: 'Erro interno ao criar o pedido.' });
    }
});

const port = 5317;
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------');
    console.log(`'Order Service' rodando na porta ${port}.`);
    console.log('----------------------------------------------------');
});