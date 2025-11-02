
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

  /// Tenta fazer login. Se der certo, salva o token.
  Future<Map<String, dynamic>> login(String email, String password) async {
    
   
    final response = await _requestHandler.post(
      '/auth/login', // Endpoint de login (exemplo)
      {'email': email, 'password': password},
    );

    
    if (response is Map<String, dynamic> && response.containsKey('token')) {
      final String token = response['token'];
      
      // SALVA o token
      await _tokenHandler.saveToken(token);
      
      return response; 
    } else {
      throw Exception('Resposta de login inválida do servidor.');
    }
  }

  // Registra um novo usuário.
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
     final response = await _requestHandler.post(
      '/auth/register', // Endpoint de registro (exemplo)
      {'name': name, 'email': email, 'password': password},
    );

    // Oregistro já faz login e retornar um token -> ele agora salva o token
    if (response is Map<String, dynamic> && response.containsKey('token')) {
      await _tokenHandler.saveToken(response['token']);
    }
    
    return response;
  }


  ///limpa o token local
  Future<void> logout() async {
    // Avisar a API que estamos deslogando
    try {
      await _requestHandler.post('/auth/logout', {});
    } catch (e) {
      // Ignora erros aqui
    }
    
    // DELETA o token local
    await _tokenHandler.deleteToken();
  }
}