const express = require('express');
const cors = require('cors');
const axios = require('axios');
const mysql = require('mysql2');

const app = express()
app.use(cors())
app.use(express.json())



const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'imtdb',
})

connection.connect(err => {
    if (err) {
        return console.error('Erro ao conectar:', err.message)
    }
    console.log('Conectado ao MySQL com sucesso')

    // TESTE: SELECT simples
    connection.query('SELECT * FROM products_db.products_tb', (err, results) => {
        if (err) {
            return console.error('Erro ao fazer SELECT:', err.message)
        }
        console.log('Resultado do SELECT:', results)
    })
})


app.get('/search', (req, res) => {
    const searchTerm = req.query.query;
    // console.log("Termo recebido:", searchTerm);

    if (!searchTerm) {
        return res.status(400).json({ error: 'Search term is required' })
    }

    const query = `SELECT * FROM products_db.products_tb WHERE name LIKE ?`
    const values = [`%${searchTerm}%`]

    connection.query(query, values, (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Internal server error' })
        }
        res.json(results)
    })
});

const port = 5240
app.listen(port, () => {
    console.clear()
    console.log('----------------------------------------------------')
    console.log(`'search products service' running at port ${port}.`)
    console.log('----------------------------------------------------')
})