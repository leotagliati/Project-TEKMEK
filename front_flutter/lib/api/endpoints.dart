import 'package:flutter_dotenv/flutter_dotenv.dart';


const undefinedUrl = 'UNDEFINED_URL';


class ApiEndpoints {
  static final String productsMSBaseUrl =
      dotenv.env['PRODUCTS_MS_BASE_URL'] ?? undefinedUrl;
  static final String cartMSBaseUrl =
      dotenv.env['CART_MS_BASE_URL'] ?? undefinedUrl;
  static final String loginMSBaseUrl =
      dotenv.env['LOGIN_MS_BASE_URL'] ?? undefinedUrl;

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

  static String cartUser = '$cartMSBaseUrl/api/checkout';
  static String cartUserItems = '$cartMSBaseUrl/api/checkout/products';
}

