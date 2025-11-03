import 'package:front_flutter/api/endpoints.dart';
import 'package:front_flutter/common_components/product.dart';
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

// adicionar os outros serviços...
