import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String productsMSBaseUrl =
      dotenv.env['PRODUCTS_MS_BASE_URL'] ?? 'UNDEFINED_URL';
  static final String loginMSBaseUrl =
      dotenv.env['LOGIN_MS_BASE_URL'] ?? 'UNDEFINED_URL';

  // Produtos
  static String get products => '$productsMSBaseUrl/api/products';
  static String productById(String id) => '$productsMSBaseUrl/api/products/$id';
  static String searchProductsByTerm(String term) =>
      '$productsMSBaseUrl/api/products/search?q=$term';

  // Login
  static String get login => '$loginMSBaseUrl/login';
  static String get register => '$loginMSBaseUrl/register';
  static String get recoverPassword => '$loginMSBaseUrl/recover-password';
  
  // autenticação
  static String get getMe => '$loginMSBaseUrl/auth/user';
}