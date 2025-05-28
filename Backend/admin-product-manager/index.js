require('dotenv').config()
const express = require('express')
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


// Adicionar teclado customizado
app.post('/keyboards', async (req, res) => {
  const { name, switch: switchType, keycaps, case_type, stabs, foam, mods, pcb, stock, price } = req.body
  
  if (!name) {
    return res.status(400).json({ error: 'O campo "name" é obrigatório' })
  }

  try {
    const result = await pool.query(
      `INSERT INTO keyboards 
       (name, switch, keycaps, case_type, stabs, foam, mods, pcb, stock, price) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) 
       RETURNING *`,
      [name, switchType, keycaps, case_type, stabs, foam, mods, pcb, stock, price]
    )
    res.status(201).json(result.rows[0])
  } catch (err) {
    if (err.code === '23505') { // Código de erro para violação de unique
      res.status(409).json({ error: 'Já existe um teclado com este nome' })
    } else {
      console.error(err)
      res.status(500).json({ error: 'Erro ao registrar teclado' })
    }
  }
})

// Listar todos os teclados
app.get('/keyboards', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT name, switch, keycaps, case_type, stabs, foam, mods, pcb, stock, price FROM keyboards ORDER BY name'
    )
    res.json(result.rows)
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao buscar teclados' })
  }
})

// Buscar teclado por nome
app.get('/keyboards/:name', async (req, res) => {
  const { name } = req.params
  try {
    const result = await pool.query(
      'SELECT * FROM keyboards WHERE name = $1',
      [name]
    )
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Teclado não encontrado' })
    }
    res.json(result.rows[0])
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao buscar teclado' })
  }
})

// Atualizar teclado
app.put('/keyboards/:name', async (req, res) => {
  const { name } = req.params
  const { switch: switchType, keycaps, case_type, stabs, foam, mods, pcb, stock, price } = req.body

  try {
    const result = await pool.query(
      `UPDATE keyboards 
       SET switch=$1, keycaps=$2, case_type=$3, stabs=$4, foam=$5, mods=$6, pcb=$7, stock=$8, price=$9 
       WHERE name=$10 
       RETURNING *`,
      [switchType, keycaps, case_type, stabs, foam, mods, pcb, stock, price, name]
    )
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Teclado não encontrado' })
    }
    
    res.json(result.rows[0])
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao atualizar teclado' })
  }
})

// Remover teclado
app.delete('/keyboards/:name', async (req, res) => {
  const { name } = req.params
  try {
    const result = await pool.query(
      'DELETE FROM keyboards WHERE name = $1 RETURNING *',
      [name]
    )
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Teclado não encontrado' })
    }
    
    res.json({ 
      success: true,
      deleted: result.rows[0]
    })
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Erro ao deletar teclado' })
  }
})

const port = process.env.PORT || 3000
app.listen(port, () => {
  console.clear()
  console.log('----------------------------------------------------')
  console.log(`Keyboard service rodando na porta ${port}`)
  console.log('----------------------------------------------------')
})