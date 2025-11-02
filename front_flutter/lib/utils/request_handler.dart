import 'dart:convert';
import 'dart:async';
import 'dart:io'; 

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

import 'token_handler.dart'; 

//Exceptions 

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

class RequestHandler {
  static final RequestHandler _instance = RequestHandler._internal();
  RequestHandler._internal();
  factory RequestHandler() {
    return _instance;
  }


  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  
 
  final TokenHandler _tokenHandler = TokenHandler();

 
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


  Uri _buildUri(String endpoint) {
    if (!endpoint.startsWith('/')) {
      endpoint = '/$endpoint';
    }
    return Uri.parse('$_baseUrl$endpoint');
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(_buildUri(endpoint), headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow; 
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .post(
            _buildUri(endpoint),
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

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .put(
            _buildUri(endpoint),
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

  Future<dynamic> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .delete(_buildUri(endpoint), headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow;
    }
  }


  Future<dynamic> _handleResponse(http.Response response) async {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body; // Sucesso
    }

    final errorMessage = (body is Map && body.containsKey('message'))
        ? body['message']
        : response.reasonPhrase ?? 'Erro desconhecido';
    
    if (statusCode == 401) {
      // Limpa o token local se a API nos rejeitar
      await _tokenHandler.deleteToken(); 
      throw UnauthorizedException(errorMessage);
    }

    throw ApiException(errorMessage, statusCode);
  }
}