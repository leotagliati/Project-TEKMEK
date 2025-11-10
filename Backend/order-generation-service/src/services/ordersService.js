import { orderRepository } from "../repositories/ordersRepository"

export const ordersService = {
    async getAll() {

    },
    async getOrdersByUserId(id) {
        return await orderRepository.getOrdersByUserId(id);
    }
}