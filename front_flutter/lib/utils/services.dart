import 'package:front_flutter/common_components/product.dart';
import 'package:front_flutter/utils/breakpoints.dart';
import 'package:front_flutter/utils/request_handler.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  ApiService._internal();
  factory ApiService() {
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
}
