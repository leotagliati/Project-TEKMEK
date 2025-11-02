import 'package:flutter_dotenv/flutter_dotenv.dart';

const undefinedUrl = 'UNDEFINED_URL';

// talvez vale apena repartir essa class por microsserviço
class ApiEndpoints {
  static final String productsMSBaseUrl =
      dotenv.env['PRODUCTS_MS_BASE_URL'] ?? undefinedUrl;
  static final String cartMSBaseUrl =
      dotenv.env['CART_MS_BASE_URL'] ?? undefinedUrl;

  static String get products => '$productsMSBaseUrl/api/products';
  static String productById(String id) => '$productsMSBaseUrl/api/products/$id';
  static String searchProductsByTerm(String term) =>
      '$productsMSBaseUrl/api/products/search?q=$term';

  static String cartUserItems = '$cartMSBaseUrl/api/checkout';
}
