const express = require('express')
const cors = require('cors')
const axios = require('axios')
const { Pool } = require('pg')

const app = express()
app.use(express.json())
app.use(cors())

const pool = new Pool({
  user: 'admin',
  host: 'localhost',
  database: 'AdminProductManager',
  password: 'admin',
  port: 5432
})

// [CREATE] - Adicionar teclado com estoque
app.post('/keyboards', async (req, res) => {
  const { name, brand, switch_type, price, stock } = req.body
  try {
    const result = await pool.query(
      'INSERT INTO keyboards (name, brand, switch_type, price, stock) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [name, brand, switch_type, price, stock]
    )
    res.status(201).json(result.rows[0])
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao registrar teclado' })
  }
})

// [READ] - Listar todos os teclados
app.get('/keyboards', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM keyboards ORDER BY id DESC')
    res.json(result.rows)
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao buscar teclados' })
  }
})

// [UPDATE] - Atualizar teclado (incluindo estoque)
app.put('/keyboards/:id', async (req, res) => {
  const { id } = req.params
  const { name, brand, switch_type, price, stock } = req.body
  try {
    const result = await pool.query(
      'UPDATE keyboards SET name=$1, brand=$2, switch_type=$3, price=$4, stock=$5 WHERE id=$6 RETURNING *',
      [name, brand, switch_type, price, stock, id]
    )
    res.json(result.rows[0])
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao atualizar teclado' })
  }
})

// [DELETE] - Remover teclado
app.delete('/keyboards/:id', async (req, res) => {
  const { id } = req.params
  try {
    await pool.query('DELETE FROM keyboards WHERE id = $1', [id])
    res.status(204).send()
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao deletar teclado' })
  }
})

const port = 12345
app.listen(port, () => {
  console.clear()
  console.log('----------------------------------------------------')
  console.log(`'Keyboard service' rodando na porta ${port}.`)
  console.log('----------------------------------------------------')
})
