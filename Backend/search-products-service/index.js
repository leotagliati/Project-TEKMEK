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


app.post('/search', (req, res) => {
    const { query, filters } = req.body;

    const layoutSizes = filters.layoutSizes || [];
    const connectivities = filters.connectivities || [];
    const productTypes = filters.productTypes || [];

    let sql = `SELECT * FROM products_db.products_tb WHERE 1 = 1`;
    const values = [];

    // Filtro por nome
    if (query && query.trim() !== '') {
        sql += ` AND name LIKE ?`;
        values.push(`%${query}%`);
    }

    // Filtro por layoutSizes
    if (layoutSizes.length > 0) {
        const placeholders = layoutSizes.map(() => '?').join(', ');
        sql += ` AND layout_size IN (${placeholders})`;
        values.push(...layoutSizes);
    }

    // Filtro por connectivities
    if (connectivities.length > 0) {
        const placeholders = connectivities.map(() => '?').join(', ');
        sql += ` AND connectivity IN (${placeholders})`;
        values.push(...connectivities);
    }

    // Filtro por productTypes
    if (productTypes.length > 0) {
        const placeholders = productTypes.map(() => '?').join(', ');
        sql += ` AND product_type IN (${placeholders})`;
        values.push(...productTypes);
    }
    // Filtro por keycapsTypes
    const keycapsTypes = filters.keycapsTypes || [];
    if (keycapsTypes.length > 0) {
        const placeholders = keycapsTypes.map(() => '?').join(', ');
        sql += ` AND keycaps_type IN (${placeholders})`;
        values.push(...keycapsTypes);
    }

    // console.log("Query SQL final:", sql);
    // console.log("Valores:", values);

    connection.query(sql, values, (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Internal server error' })
        }
        // console.log("Produtos encontrados:");
        // results.forEach((produto, index) => {
        //     console.log(`${index + 1}. ${produto.name} - R$${produto.price}`);
        // });
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