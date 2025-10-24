import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'UNDEFINED_URL';
  static final String productsAPIPort = dotenv.env['PRODUCTS_MS_PORT'] ?? 'UNDEFINED_PORT';

  static String get login => '$baseUrl/api/login';
  static String get products => '$baseUrl:$productsAPIPort/api/products';
}
