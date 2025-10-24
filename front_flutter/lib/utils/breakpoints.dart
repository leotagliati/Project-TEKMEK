import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'default_url';

  static String get login => '$baseUrl/api/login';
  static String get products => '$baseUrl/api/products';
}
