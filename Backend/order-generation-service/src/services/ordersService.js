import { orderRepository } from "../repositories/ordersRepository"

export const ordersService = {
    async getOrdersByUserId(id) {
        return await orderRepository.getOrdersByUserId(id);
    }
}