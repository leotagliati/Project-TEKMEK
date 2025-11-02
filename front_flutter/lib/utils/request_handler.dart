import 'dart:convert';
import 'dart:async';
import 'dart:io'; // Para SocketException (sem internet)

import 'package:http/http.dart' as http;
import 'token_handler.dart'; 

// Exceções personalizadas 

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



  //  Agora aceita 'urlCompleta' em vez de 'endpoint'
  Future<dynamic> get(String urlCompleta) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse(urlCompleta), headers: headers); // Usa a URL completa
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow; 
    }
  }


  Future<dynamic> post(String urlCompleta, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .post(
            Uri.parse(urlCompleta),
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


  Future<dynamic> put(String urlCompleta, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .put(
            Uri.parse(urlCompleta), 
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

 
  Future<dynamic> delete(String urlCompleta) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .delete(Uri.parse(urlCompleta), headers: headers);
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
        // O back-end manda 'error' em vez de 'message' às vezes
        : (body is Map && body.containsKey('error')) 
            ? body['error']
            : response.reasonPhrase ?? 'Erro desconhecido';
    
    if (statusCode == 401) {
      // Limpa o token local se a API rejeitar
      await _tokenHandler.deleteToken(); 
      throw UnauthorizedException(errorMessage);
    }

    throw ApiException(errorMessage, statusCode);
  }
}