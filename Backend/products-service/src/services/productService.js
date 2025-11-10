import { productRepository } from '../repositories/productRepository.js';
import { emitEvent } from './eventService.js';

export const productService = {
    async getAll() {
        return await productRepository.getAll();
    },

    async getById(id) {
        return await productRepository.getById(id);
    },

    async searchByName(name) {
        return await productRepository.searchByName(name);
    },

    async filter(filters) {
        const { layoutSize = [], connectionType = [], productType = [], keycapsType = [] } = filters;
        let products = await productRepository.getAll();

        if (layoutSize.length > 0) products = products.filter(p => layoutSize.includes(p.layout_size));
        if (connectionType.length > 0) products = products.filter(p => connectionType.includes(p.connectivity));
        if (productType.length > 0) products = products.filter(p => productType.includes(p.product_type));
        if (keycapsType.length > 0) products = products.filter(p => keycapsType.includes(p.keycaps_type));

        return products;
    },

    async create(data) {
        const product = await productRepository.create(data);
        await emitEvent('ProductCreated', product);
        return product;
    },

    async update(id, data) {
        const product = await productRepository.update(id, data);
        if (!product) return null;
        await emitEvent('ProductUpdated', product);
        return product;
    }
};
