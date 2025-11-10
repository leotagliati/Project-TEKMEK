import { pool } from '../config/database.js';
import { Product } from '../models/productModel.js';

export const productRepository = {
    async getAll() {
        const { rows } = await pool.query('SELECT * FROM products_tb');
        return rows.map(r => new Product(r));
    },

    async getById(id) {
        const { rows } = await pool.query('SELECT * FROM products_tb WHERE id = $1', [id]);
        return rows[0] ? new Product(rows[0]) : null;
    },

    async searchByName(name) {
        const searchTerm = `%${name}%`;
        const { rows } = await pool.query('SELECT * FROM products_tb WHERE name ILIKE $1', [searchTerm]);
        return rows.map(r => new Product(r));
    },

    async create(product) {
        const { name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type } = product;
        const { rows } = await pool.query(
            `INSERT INTO products_tb (name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
       RETURNING *`,
            [name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type]
        );
        return new Product(rows[0]);
    },

    async update(id, data) {
        const { name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type } = data;
        const { rows } = await pool.query(
            `UPDATE products_tb SET
        name=$1, description=$2, price=$3, image_url=$4,
        layout_size=$5, connectivity=$6, product_type=$7, keycaps_type=$8
       WHERE id=$9 RETURNING *`,
            [name, description, price, image_url, layout_size, connectivity, product_type, keycaps_type, id]
        );
        return rows[0] ? new Product(rows[0]) : null;
    }
};
