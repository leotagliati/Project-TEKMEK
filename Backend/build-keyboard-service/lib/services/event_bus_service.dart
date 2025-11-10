import 'dart:convert';
import 'dart:io';

import 'package:cart_service/config/environment.dart';

class EventBusService {
  static Future<bool> sendCheckoutEvent(Map<String, dynamic> event) async {
    final httpClient = HttpClient();
    final request =
        await httpClient.postUrl(Uri.parse(Environment.eventBusUrl));
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(event));

    final response = await request.close();
    return response.statusCode == 200;
  }
}
