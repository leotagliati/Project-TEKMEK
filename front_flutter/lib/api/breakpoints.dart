import 'package:flutter_dotenv/flutter_dotenv.dart';

// talvez vale apena repartir essa class por microsserviço
class ApiEndpoints {
  static final String productsMSBaseUrl =
      dotenv.env['PRODUCTS_MS_BASE_URL'] ?? 'UNDEFINED_URL';
  static final String loginMSBaseUrl =
      dotenv.env['LOGIN_MS_BASE_URL'] ?? 'UNDEFINED_URL';

  static String get products => '$productsMSBaseUrl/api/products';
  static String productById(String id) => '$productsMSBaseUrl/api/products/$id';

  static String get login => '$loginMSBaseUrl/api/login';
}
