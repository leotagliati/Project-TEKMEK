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

    client.query('SELECT * FROM products_tb', (err, result) => {
        release();
        if (err) {
            return console.error('Erro ao fazer SELECT:', err.stack);
        }
        console.log('Resultado do SELECT:', result.rows);
    });
});

// Rota de busca com filtros
app.post('/search', async (req, res) => {
    const { filters, searchTerm } = req.body;

    const layoutSizes = filters.layoutSizes || [];
    const connectivities = filters.connectivities || [];
    const productTypes = filters.productTypes || [];
    const keycapsTypes = filters.keycapsTypes || [];

    try {
        const result = await pool.query('SELECT * FROM products_tb');
        let filtered = result.rows;

        if (layoutSizes.length > 0) {
            filtered = filtered.filter(p => layoutSizes.includes(p.layout_size));
        }
        if (connectivities.length > 0) {
            filtered = filtered.filter(p => connectivities.includes(p.connectivity));
        }
        if (productTypes.length > 0) {
            filtered = filtered.filter(p => productTypes.includes(p.product_type));
        }
        if (keycapsTypes.length > 0) {
            filtered = filtered.filter(p => keycapsTypes.includes(p.keycaps_type));
        }
        if (searchTerm) {
            const term = searchTerm.toLowerCase();
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
app.get('/product/:title', async (req, res) => {
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

// Rota de evento (mock)
app.get('/event', (req, res) => {
    const eventType = req.query.type;

    if (!eventType) {
        return res.status(400).json({ error: 'Tipo de evento não especificado.' });
    }

    if (['UserRegistered', 'UserLogged'].includes(eventType)) {
        console.log(`Evento ${eventType} recebido pelo Search Products Service`);
    }

    res.status(200).json({ status: 'Evento processado.' });
});

// Inicialização do servidor
const port = 5240;
app.listen(port, () => {
    console.clear();
    console.log('----------------------------------------------------');
    console.log(`'search products service' running at port ${port}.`);
    console.log('----------------------------------------------------');
});
