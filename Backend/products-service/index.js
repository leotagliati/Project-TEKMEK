require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const axios = require('axios');

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
});

// Teste de conexão
pool.connect((err, client, release) => {
  if (err) {
    return console.error('Erro ao conectar ao PostgreSQL:', err.stack);
  }
  console.log('Conectado ao PostgreSQL com sucesso');
  release();
});

const EVENT_BUS_URL = process.env.EVENT_BUS_URL || 'UNDEFINED_URL';

async function emitEvent(type, data) {
  try {
    await axios.post(EVENT_BUS_URL, { type, data });
    console.log(`[EVENTO ENVIADO] ${type}`);
  } catch (err) {
    console.error(`[ERRO] Falha ao enviar evento ${type}:`, err.message);
  }
}

// =====================================================
// ROTAS DE PRODUTOS
// =====================================================

// Busca com filtros
app.post('/api/products/search', async (req, res) => {
  const { q } = req.query;
  const { layoutSize, connectionType } = req.body;

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

    if (layoutSize && layoutSize.length > 0) {
      filtered = filtered.filter(p => layoutSize.includes(p.layout_size));
    }

    if (connectionType && connectionType.length > 0) {
      filtered = filtered.filter(p => connectionType.includes(p.connectivity));
    }

    res.json(filtered);
  } catch (err) {
    console.error('Erro na busca:', err.stack);
    res.status(500).json({ error: 'Erro interno do servidor.' });
  }
});

// Listar todos os produtos
app.get('/api/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products_tb');
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Nenhum produto encontrado.' });
    }
    res.json(result.rows);
  } catch (err) {
    console.error('Erro ao buscar produtos:', err.stack);
    res.status(500).json({ error: 'Erro interno do servidor.' });
  }
});

// Buscar produto por ID
app.get('/api/products/:id', async (req, res) => {
  const productId = req.params.id;
  try {
    const result = await pool.query(
      'SELECT * FROM products_tb WHERE id = $1',
      [productId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: `Produto de id#${productId} não existe.` });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(`Erro ao buscar produto id#${productId}:`, err.stack);
    res.status(500).json({ error: 'Erro interno do servidor.' });
  }
});

// Criar novo produto
app.post('/api/products', async (req, res) => {
  const { name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO products_tb (name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING *`,
      [name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type]
    );

    const newProduct = result.rows[0];
    await emitEvent('ProductCreated', newProduct);

    res.status(201).json(newProduct);
  } catch (err) {
    console.error('Erro ao criar produto:', err.stack);
    res.status(500).json({ error: 'Erro interno ao criar produto.' });
  }
});

// Atualizar produto existente
app.put('/api/products/:id', async (req, res) => {
  const productId = req.params.id;
  const { name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type } = req.body;

  try {
    const result = await pool.query(
      `UPDATE products_tb
       SET name = $1, description = $2, price = $3, image_url = $4,
           layout_size = $5, connectivity = $6, product_type = $7, keycaps_type = $8
       WHERE id = $9
       RETURNING *`,
      [name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type, productId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: `Produto id#${productId} não encontrado.` });
    }

    const updatedProduct = result.rows[0];
    await emitEvent('ProductUpdated', updatedProduct);

    res.json(updatedProduct);
  } catch (err) {
    console.error(`Erro ao atualizar produto id#${productId}:`, err.stack);
    res.status(500).json({ error: 'Erro interno ao atualizar produto.' });
  }
});

// Endpoint para eventos recebidos
app.post('/event', async (req, res) => {
  const { type, data } = req.body;
  console.log('Evento recebido:', type);
  res.sendStatus(200);
});

// Inicialização do servidor
const port = process.env.MS_PORT;
app.listen(port, () => {
  console.clear();
  console.log('----------------------------------------------------');
  console.log(`'products service' rodando na porta ${port}.`);
  console.log('----------------------------------------------------');
});
