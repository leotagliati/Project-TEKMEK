require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());
app.use(express.json());

// Configuração da conexão PostgreSQL
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT
})

// Teste de conexão
pool.connect((err, client, release) => {
    if (err) {
        return console.error('Erro ao conectar ao PostgreSQL:', err.stack);
    }
    console.log('Conectado ao PostgreSQL com sucesso');
    release();
});

app.get('/api/products/search', async (req, res) => {
    const { q } = req.query; // <--- pega o valor de ?q=blablabla

    try {
        const result = await pool.query('SELECT * FROM products_tb');
        let filtered = result.rows;

        if (q) {
            const term = q.toLowerCase();
            filtered = filtered.filter(p =>
                p.name.toLowerCase().includes(term) ||
                (p.description && p.description.toLowerCase().includes(term))
            );
        }

        res.json(filtered);
    } catch (err) {
        console.error('Erro na busca:', err.stack);
        res.status(500).json({ error: 'Erro interno do servidor.' });
    }
});


// Rota para buscar produto por título
app.get('/products/search', async (req, res) => {
    const title = req.params.title;

    try {
        const result = await pool.query(
            'SELECT * FROM products_tb WHERE name = $1',
            [title]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Produto não encontrado.' });
        }

        res.json(result.rows[0]);
    } catch (err) {
        console.error('Erro ao buscar produto:', err.stack);
        res.status(500).json({ error: 'Erro interno do servidor.' });
    }
});

app.get('/api/products', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT * FROM products_tb'
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Produto não encontrado.' });
        }
        res.json(result.rows);
    } catch (err) {
        console.error('Erro ao buscar produto:', err.stack);
        res.status(500).json({ error: 'Erro interno do servidor.' });
    }
});

app.post('/event', async (req, res) => {
    const { type, data } = req.body;

    console.log('Evento recebido:', type);

    if (!type) {
        return res.status(400).json({ error: 'Tipo de evento não especificado.' });
    }

    if (['ProductCreated', 'ProductDeleted'].includes(type)) {
        console.log(`Evento ${type} recebido pelo Search Products Service`);
        try {
            if (type === 'ProductCreated') {
                const query = `
                    INSERT INTO products_tb (id, name, description, price, layout_size, connectivity, product_type, keycaps_type)
                    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                    ON CONFLICT (id) DO UPDATE SET
                        name = EXCLUDED.name,
                        description = EXCLUDED.description,
                        price = EXCLUDED.price,
                        layout_size = EXCLUDED.layout_size,
                        connectivity = EXCLUDED.connectivity,
                        product_type = EXCLUDED.product_type,
                        keycaps_type = EXCLUDED.keycaps_type;
                `;

                await pool.query(query, [
                    data.id,
                    data.name,
                    data.description,
                    parseFloat(data.price),
                    data.layout_size,
                    data.connectivity,
                    data.product_type,
                    data.keycaps_type
                ]);

                console.log(`Produto ${data.id} inserido/atualizado na base local.`);

            } else if (type === 'ProductDeleted') {
                const query = 'DELETE FROM products_tb WHERE id = $1';
                await pool.query(query, [data.id]);
                console.log(`Produto ${data.id} deletado da base local.`);
            }

            return res.status(200).json({ status: 'Evento processado com sucesso.' });
        } catch (error) {
            console.error('Erro ao atualizar base local:', error);
            return res.status(500).json({ error: 'Erro ao atualizar base local.' });
        }
    }

});

// Inicialização do servidor
const port = process.env.MS_PORT
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------');
    console.log(`'search products service' running at port ${port}.`);
    console.log('----------------------------------------------------');
});
