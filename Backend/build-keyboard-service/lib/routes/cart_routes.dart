import 'package:cart_service/controllers/cart_controller.dart';
import 'package:shelf_router/shelf_router.dart';

Router cartRoutes(CartController controller) {
  final router = Router();

  // GET carrinho por userId
  router.get('/api/checkout', controller.getCart);

  // GET produtos do carrinho
  router.get('/api/checkout/products', controller.getCartProducts);

  // POST item no carrinho
  router.post('/api/checkout', controller.addToCart);

  // PUT item (atualizar quantidade/preço)
  router.put('/api/checkout', controller.updateCartItem);

  // DELETE item
  router.delete('/api/checkout', controller.removeFromCart);

  // POST evento de checkout (enviar para barramento)
  router.post('/api/req-order', controller.checkout);

  // POST recebe os eventos
  router.post('/event', controller.handleEvent);

  return router;
}
