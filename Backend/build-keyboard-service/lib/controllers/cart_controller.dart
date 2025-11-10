import 'dart:convert';
import 'package:cart_service/repositories/cart_repo.dart';
import 'package:cart_service/services/event_bus_service.dart';
import 'package:shelf/shelf.dart';

class CartController {
  final CartRepository repository;

  CartController(this.repository);

  // GET /api/checkout?userId=1
  Future<Response> getCart(Request req) async {
    final userId = int.tryParse(req.url.queryParameters['userId'] ?? '');
    if (userId == null) {
      return Response(400, body: jsonEncode({'error': 'userId é obrigatório'}));
    }

    final items = await repository.getCartByUser(userId);
    return Response.ok(jsonEncode(items.map((e) => e.toJson()).toList()),
        headers: {'Content-Type': 'application/json'});
  }

  // GET /api/checkout/products?userId=1
  Future<Response> getCartProducts(Request req) async {
    final userId = int.tryParse(req.url.queryParameters['userId'] ?? '');
    if (userId == null) {
      return Response(400,
          body: jsonEncode({'error': 'userId é obrigatório'}),
          headers: {'Content-Type': 'application/json'});
    }

    try {
      final items = await repository.getCartProductsByUser(userId);
      return Response.ok(
        jsonEncode(items),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao buscar produtos do carrinho: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /api/checkout
  Future<Response> addToCart(Request req) async {
    final body = jsonDecode(await req.readAsString());
    final userId = body['userId'];
    final productId = body['productId'];
    final quantity = body['quantity'] ?? 1;
    final rawPrice = body['price'];

    if (userId == null ||
        productId == null ||
        quantity == null ||
        rawPrice == null) {
      return Response(400,
          body: jsonEncode({'error': 'Parâmetros inválidos'}),
          headers: {'Content-Type': 'application/json'});
    }
    final price = (rawPrice is int)
        ? rawPrice.toDouble()
        : (rawPrice is double)
            ? rawPrice
            : double.tryParse(rawPrice.toString());

    if (price == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'Preço inválido'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    try {
      await repository.addItem(userId, productId, quantity, price);
      return Response.ok(
        jsonEncode({'message': 'Produto adicionado ao carrinho'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao adicionar produto: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /api/checkout
  Future<Response> updateCartItem(Request req) async {
    final body = jsonDecode(await req.readAsString());
    final userId = body['userId'];
    final productId = body['productId'];
    final newQuantity = body['quantity'];
    final newRawPrice = body['price'];

    if (userId == null ||
        productId == null ||
        newQuantity == null ||
        newRawPrice == null) {
      return Response(400,
          body: jsonEncode({'error': 'Parâmetros inválidos'}),
          headers: {'Content-Type': 'application/json'});
    }
    final price = (newRawPrice is int)
        ? newRawPrice.toDouble()
        : (newRawPrice is double)
            ? newRawPrice
            : double.tryParse(newRawPrice.toString());

    if (price == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'Preço inválido'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    try {
      await repository.updateItem(userId, productId, price, newQuantity);
      return Response.ok(
          jsonEncode({'message': 'Quantidade atualizada com sucesso'}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao atualizar item: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // DELETE /api/checkout
  Future<Response> removeFromCart(Request req) async {
    final body = jsonDecode(await req.readAsString());
    final userId = body['userId'];
    final productId = body['productId'];

    if (userId == null || productId == null) {
      return Response(400,
          body: jsonEncode({'error': 'userId e productId são obrigatórios'}),
          headers: {'Content-Type': 'application/json'});
    }

    try {
      await repository.deleteItem(userId, productId);
      return Response.ok(
          jsonEncode({'message': 'Produto removido do carrinho'}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao remover produto: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // DELETE /api/checkout?userId=1
  Future<Response> clearCart(Request req) async {
    final userId = int.tryParse(req.url.queryParameters['userId'] ?? '');
    if (userId == null) {
      return Response(400,
          body: jsonEncode({'error': 'userId é obrigatório'}),
          headers: {'Content-Type': 'application/json'});
    }

    try {
      await repository.clearCart(userId);
      return Response.ok(jsonEncode({'message': 'Carrinho limpo com sucesso'}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao limpar carrinho: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /api/checkout
  Future<Response> checkout(Request req) async {
    final body = jsonDecode(await req.readAsString());
    final userId = body['userId'];
    if (userId == null) {
      return Response(400, body: jsonEncode({'error': 'userId é obrigatório'}));
    }

    final items = await repository.getCartByUser(userId);
    if (items.isEmpty) {
      return Response.ok(
        jsonEncode({'message': 'Carrinho vazio', 'items': []}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final event = {
      'type': 'CartCheckoutInitiated',
      'data': {
        'userId': userId,
        'items': items.map((i) => i.toJson()).toList(),
      }
    };

    final sent = await EventBusService.sendCheckoutEvent(event);
    if (sent) {
      await repository.clearCart(userId);
      return Response.ok(
        jsonEncode({'message': 'Checkout realizado com sucesso'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.internalServerError(
      body: jsonEncode({'error': 'Falha ao enviar evento'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // GET /api/checkout/products?userId=1
  Future<Response> getCheckoutProducts(Request req) async {
    final userId = int.tryParse(req.url.queryParameters['userId'] ?? '');
    if (userId == null) {
      return Response(400,
          body: jsonEncode({'error': 'userId é obrigatório'}),
          headers: {'Content-Type': 'application/json'});
    }

    try {
      final items = await repository.getCartProductsByUser(userId);
      return Response.ok(
          jsonEncode({
            'checkoutItems': items,
          }),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao buscar produtos do checkout: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> handleEvent(Request req) async {
    try {
      final payload = await req.readAsString();
      final event = jsonDecode(payload);

      final type = event['type'];
      final data = event['data'];

      print('Evento recebido: $type');
      print('Dados: $data');

      switch (type) {
        case 'ProductCreated':
          await repository.insertCartProduct(
            productId: data['id'],
            name: data['name'],
            price: (data['price'] is int)
                ? (data['price'] as int).toDouble()
                : (data['price'] is double)
                    ? data['price']
                    : double.tryParse(data['price'].toString()) ?? 0.0,
            imageUrl: data['image_url'],
          );
          print('Tabela de produto sincronizada: ${data['name']}');
          break;

        case 'ProductUpdated':
          await repository.updateCartProduct(
            productId: data['id'],
            name: data['name'],
            price: (data['price'] is int)
                ? (data['price'] as int).toDouble()
                : (data['price'] is double)
                    ? data['price']
                    : double.tryParse(data['price'].toString()) ?? 0.0,
            imageUrl: data['image_url'],
          );
          print('Tabela de produto sincronizada: ${data['name']}');
          break;

        case 'ProductDeleted':
          final productId = data['id'];
          if (productId != null) {
            await repository.deleteCartProduct(productId);
            print('Tabela de produto sincronizada: ${data['name']}');
          }
          break;

        default:
          print(
              'Evento ignorado: $type'); // nao deve acontecer, ja que o barramento envia somente pra quem ouve
      }

      return Response.ok(
        jsonEncode({'status': 'Evento processado com sucesso'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Erro ao processar evento: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Falha ao processar evento: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
