require('dotenv').config()
const express = require('express')
const axios = require('axios')
const cors = require('cors')
const { Pool } = require('pg')

const app = express()
app.use(express.json())
app.use(cors())

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT
})

// Teste de conexão com o banco
pool.connect((err, client, release) => {
  if (err) {
    console.error('Erro ao conectar ao PostgreSQL:', err)
    process.exit(1)
  }
  console.log('Conectado ao PostgreSQL com sucesso!')
  release()
})

app.post('/products', async (req, res) => {
  const {
    name,
    description,
    price,
    image_url,
    layout_size,
    connectivity,
    product_type,
    keycaps_type
  } = req.body

  if (!name) {
    return res.status(400).json({ error: 'O campo "name" é obrigatório' })
  }

  try {
    const result = await pool.query(
      `INSERT INTO products_tb
      (name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *`,
      [name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type]
    )

    res.status(201).json(result.rows[0])
    await axios.post('http://localhost:5300/event', {
      type: 'ProductCreated',
      data: result.rows[0]
    })
    console.log(`Evento 'ProductCreated',' enviado com sucesso para o barramento de eventos.`)


  } catch (err) {
    if (err.code === '23505') {
      res.status(409).json({ error: 'Já existe um produto com este nome' })
    } else {
      console.error(err)
      res.status(500).json({ error: 'Erro ao registrar produto' })
    }
  }
})

app.get('/products', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type, created_at
       FROM products_tb
       ORDER BY created_at DESC`
    )
    res.json(result.rows)
    await axios.post('http://localhost:5300/event', {
      type: 'ProductsFetched',
      data: result.rows
    });
    console.log(`Evento 'ProductsFetched' enviado com sucesso para o barramento de eventos.`)
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao buscar produtos' })
  }
})
app.delete('/products/:id', async (req, res) => {
  const { id } = req.params

  try {
    const result = await pool.query('DELETE FROM products_tb WHERE id = $1 RETURNING *', [id])
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Produto não encontrado' })
    }
    res.json(result.rows[0])

    await axios.post('http://localhost:5300/event', {
      type: 'ProductDeleted',
      data: { id }
    });
    console.log(`Evento 'ProductDeleted' enviado com sucesso para o barramento de eventos.`)

  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao deletar produto' })
  }
})


const port = process.env.MS_PORT
app.listen(port, () => {
  console.clear()
  console.log('----------------------------------------------------')
  console.log(`Keyboard service rodando na porta ${port}`)
  console.log('----------------------------------------------------')
})