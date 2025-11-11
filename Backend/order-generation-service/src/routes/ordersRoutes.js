const { Router } = require("express");
const { ordersController } = require("../controllers/ordersController");

const router = Router();

router.get('/user', ordersController.getOrdersByUserId);

export default router;