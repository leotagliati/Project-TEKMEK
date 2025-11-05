
import 'endpoints.dart'; 
import 'package:front_flutter/utils/request_handler.dart';
import 'package:front_flutter/utils/token_handler.dart'; 

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() {
    return _instance;
  }

 
  final RequestHandler _requestHandler = RequestHandler();
  final TokenHandler _tokenHandler = TokenHandler();

  // Tenta fazer login se okk salva token
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    
      // faz a requisição de login
    final response = await _requestHandler.post(
      ApiEndpoints.login, 
      {'username': email, 'password': password}, // Conforme API Node.js
    );

    //Processa a resposta do back-end (que contém 'token' e 'user')
    if (response is Map<String, dynamic> && response.containsKey('token')) {
      final String token = response['token'];
      
      // Salva o token
      await _tokenHandler.saveToken(token);
      
      // Retorna só os dados do usuário
      return response['user'] as Map<String, dynamic>; 
    } else {
      throw Exception('Resposta de login inválida do servidor.');
    }
  }

  /// Tenta registrar um novo usuário.
  Future<dynamic> register(String email, String password) async {
     final response = await _requestHandler.post(
      ApiEndpoints.register, // Passa a URL COMPLETA
      {'username': email, 'password': password},
    );
    
    // retorna 201 e dados do user
    return response;
  }


  /// Inicia a recuperação de senha - faz nada 
  Future<dynamic> recoverPassword(String email) async {
    final response = await _requestHandler.post(
      ApiEndpoints.recoverPassword,
      {'username': email},
    );
    return response; 
  }
  


  // Desloga o usuário -> apaga token local
  Future<void> logout() async {

    // DELETA o token local
    await _tokenHandler.deleteToken();
  }
}