import { productService } from '../services/productService.js';

export const productController = {
    async getAll(req, res) {
        try {
            const products = await productService.getAll();
            if (products.length === 0)
                return res.status(404).json({ error: 'Nenhum produto encontrado.' });
            res.json(products);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Erro ao buscar produtos.' });
        }
    },

    async getById(req, res) {
        try {
            const product = await productService.getById(req.params.id);
            if (!product) return res.status(404).json({ error: 'Produto não encontrado.' });
            res.json(product);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Erro ao buscar produto.' });
        }
    },

    async search(req, res) {
        try {
            const { q } = req.query;
            if (!q) return res.status(400).json({ error: 'Parâmetro q obrigatório.' });
            const products = await productService.searchByName(q);
            res.json(products);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Erro na busca.' });
        }
    },

    async filter(req, res) {
        try {
            const products = await productService.filter(req.body);
            res.json(products);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Erro ao filtrar produtos.' });
        }
    },

    async create(req, res) {
        try {
            const newProduct = await productService.create(req.body);
            res.status(201).json(newProduct);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Erro ao criar produto.' });
        }
    },

    async update(req, res) {
        try {
            const updated = await productService.update(req.params.id, req.body);
            if (!updated) return res.status(404).json({ error: 'Produto não encontrado.' });
            res.json(updated);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Erro ao atualizar produto.' });
        }
    }
};
