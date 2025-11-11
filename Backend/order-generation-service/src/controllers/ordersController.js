import { ordersService } from "../services/ordersService"

export const ordersController = {
    async getOrdersByUserId(req, res) {
        try {
            const orders = await ordersService.getOrdersByUserId(req.params.id);
            if (!orders || orders.length === 0) return res.status(404).json({ error: 'Nenhum pedido encontrado.' });
            res.json(orders);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: `Erro ao buscar pedidos do usuário de id:${req.params.id} .` });
        }
    }
}