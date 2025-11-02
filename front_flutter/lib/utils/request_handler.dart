import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestHandler {
  static final RequestHandler _instance = RequestHandler._internal();
  RequestHandler._internal();
  factory RequestHandler() => _instance;

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Monta a URI com query params, se existirem
  Uri _buildUri(String url, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse(url);
    if (queryParams == null || queryParams.isEmpty) return uri;
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...queryParams.map((k, v) => MapEntry(k, v.toString())),
    });
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParams}) async {
    final uri = _buildUri(url, queryParams);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? queryParams}) async {
    final uri = _buildUri(url, queryParams);
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? queryParams}) async {
    final uri = _buildUri(url, queryParams);
    final response = await http.put(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String url,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? body}) async {
    final uri = _buildUri(url, queryParams);
    final response = await http.delete(
      uri,
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      throw Exception(
        'Erro na requisição: [$statusCode] ${response.reasonPhrase}',
      );
    }
  }
}
