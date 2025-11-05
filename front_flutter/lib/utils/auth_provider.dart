import 'package:flutter/material.dart';
import 'package:front_flutter/api/auth_service.dart';
import 'package:front_flutter/utils/token_handler.dart'; 

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenHandler _tokenHandler = TokenHandler(); 


  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;


  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  bool get isAdmin => _user?['isAdmin'] ?? false; 

  AuthProvider() {
    _tryAutoLogin(); // Tenta logar automaticamente ao iniciar
  }

  // Checa se já existe um token válido ao abrir o app
  Future<void> _tryAutoLogin() async {
    final token = await _tokenHandler.getToken();
    if (token != null) {
     //adiconar logica para buscar dados do usuario com o token
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  // Função de Login
  Future<void> login(String email, String password) async {
 
    final userData = await _authService.login(email, password);

    _user = userData;
    _isLoggedIn = true;

    // Notifica a UI e o GoRouter
    notifyListeners();
  }

  // Função de Logout
  Future<void> logout() async {

    await _authService.logout(); 
    // Deleta o token

    //  Limpa o ESTADO
    _user = null;
    _isLoggedIn = false;

    // Notifica a UI e o GoRouter
    notifyListeners();
  }

  // A função de registro não loga o usuário,
  // apenas o `AuthService.register` é chamado pela LoginScreen
}