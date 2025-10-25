import 'package:front_flutter/api/endpoints.dart';
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

  // adicionar os outros metodos de acesso...
}

// adicionar os outros serviços...
