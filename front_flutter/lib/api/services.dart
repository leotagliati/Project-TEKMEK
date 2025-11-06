import 'package:front_flutter/api/endpoints.dart';
import 'package:front_flutter/models/product.dart';
import 'package:front_flutter/utils/request_handler.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  ProductsService._internal();
  factory ProductsService() {
    return _instance;
  }

  final RequestHandler _requestHandler = RequestHandler();

  Future<List<dynamic>> getProducts() async {
    final response = await _requestHandler.get(ApiEndpoints.products);
    if (response is List) {
      return response;
    } else {
      throw Exception('Resposta inesperada do servidor');
    }
  }

  Future<Product> getProductById(String id) async {
    final response = await _requestHandler.get(ApiEndpoints.productById(id));
    if (response is Map<String, dynamic>) {
      return Product.fromJson(response);
    } else {
      throw Exception('Resposta inesperada do servidor');
    }
  }

  Future<List<dynamic>> searchProducts(String term) async {
    final response = await _requestHandler.get(
      ApiEndpoints.searchProductsByTerm(term),
    );
    if (response is List) {
      return response;
    } else {
      throw Exception('Resposta inesperada do servidor');
    }
  }

  // adicionar os outros metodos de acesso...
}

class CartService {
  static final CartService _instance = CartService._internal();
  CartService._internal();
  factory CartService() {
    return _instance;
  }

  final RequestHandler _requestHandler = RequestHandler();

  Future<List<dynamic>> getUserItems(String userId) async {
    final response = await _requestHandler.get(
      ApiEndpoints.cartUserItems,
      queryParams: {'userId': userId},
    );
    if (response is List) {
      return response;
    } else {
      throw Exception('Resposta inesperada do servidor');
    }
  }

  Future<dynamic> addItemToCart(Map<String, dynamic> body) async {
    final response = await _requestHandler.post(ApiEndpoints.cartUser, body);
    return response;
  }

  Future<void> updateCartItem(Map<String, dynamic> body) async {
    await _requestHandler.put(ApiEndpoints.cartUser, body);
  }

  Future<void> removeCartItem(Map<String, dynamic> body) async {
    await _requestHandler.delete(ApiEndpoints.cartUser, body: body);
  }

  Future<void> checkoutItems(Map<String, dynamic> body) async {
    final response = await _requestHandler.post(
      ApiEndpoints.cartCheckout,
      body,
    );
    return response;
  }
}

class OrdersService {
  static final OrdersService _instance = OrdersService._internal();
  OrdersService._internal();
  factory OrdersService() {
    return _instance;
  }

  final RequestHandler _requestHandler = RequestHandler();

  Future<List<dynamic>> getUserItems(int userId) async {
    final response = await _requestHandler.get(
      ApiEndpoints.userOrders,
      queryParams: {'userId': userId},
    );
    if (response is List) {
      return response;
    } else {
      throw Exception('Resposta inesperada do servidor');
    }
  }
}

// adicionar os outros serviços...
