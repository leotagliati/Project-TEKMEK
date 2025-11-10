export const orderRepository = {
    async getOrdersByUserId(id) {
        const { rows } = await pool.query(
            `SELECT 
                o.id AS order_id,
                o.status,
                o.valor_total,
                o.created_at,
                oi.product_id,
                oi.quantity,
                oi.price,
                op.name AS product_name,
                op.image_url AS product_image
             FROM orders_tb o
             JOIN order_items_tb oi ON o.id = oi.order_id
             JOIN order_products_tb op ON oi.product_id = op.product_id
             WHERE o.user_id = $1
             ORDER BY o.created_at DESC`,
            [id]
        );
        return rows.map(rowData => new Order(rowData))
    }
}