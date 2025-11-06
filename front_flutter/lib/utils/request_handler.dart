import 'dart:convert';

import 'dart:async';
import 'dart:io'; // Para SocketException

import 'package:http/http.dart' as http;
import 'token_handler.dart'; // Assumindo que este arquivo existe

// --- Exceções personalizadas ---

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => '[$statusCode] $message';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

class NetworkException implements Exception {
  @override
  String toString() => 'Sem conexão com a internet. Verifique sua rede.';
}

// --- Request Handler ---

class RequestHandler {
  static final RequestHandler _instance = RequestHandler._internal();
  RequestHandler._internal();
  factory RequestHandler() => _instance;

  final TokenHandler _tokenHandler = TokenHandler();

  /// Monta a URI com query params, se existirem

  Uri _buildUri(String url, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse(url);
    if (queryParams == null || queryParams.isEmpty) return uri;
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParams.map((k, v) => MapEntry(k, v.toString())),
      },
    );
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body; // Sucesso
    }

    final errorMessage = (body is Map && body.containsKey('message'))
        ? body['message']
        : (body is Map && body.containsKey('error'))
        ? body['error']
        : response.reasonPhrase ?? 'Erro desconhecido';

    if (statusCode == 401) {
      await _tokenHandler.deleteToken();
      throw UnauthorizedException(errorMessage);
    }

    throw ApiException(errorMessage, statusCode);
  }

  /// Adiciona headers padrões e o token de autenticação
  Future<Map<String, String>> _getHeaders() async {
    final token = await _tokenHandler.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParams}) async {
    final uri = _buildUri(url, queryParams);
    try {
      final headers = await _getHeaders();
      final response = await http.get(uri, headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = _buildUri(url, queryParams);
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = _buildUri(url, queryParams);
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(url, queryParams);
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow;
    }
  }
}
