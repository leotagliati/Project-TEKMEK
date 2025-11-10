import { Router } from 'express';
import { productController } from '../controllers/productController.js';

const router = Router();

router.get('/', productController.getAll);
router.get('/search', productController.search);
router.get('/:id', productController.getById);
router.post('/filter', productController.filter);
router.post('/', productController.create);
router.put('/:id', productController.update);

export default router;
