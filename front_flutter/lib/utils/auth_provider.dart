import 'package:flutter/material.dart';
import 'package:front_flutter/api/auth_service.dart';
import 'package:front_flutter/utils/token_handler.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenHandler _tokenHandler = TokenHandler();

  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  bool get isAdmin => _user?['isAdmin'] ?? false;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    final token = await _tokenHandler.getToken();
    if (token != null) {
      try {
        final userData = await _authService.getMe();
        _user = userData;
        _isLoggedIn = true;
      } catch (e) {
        // Token é inválido ou expirou, limpa
        await _tokenHandler.deleteToken();
        _isLoggedIn = false;
        _user = null;
      }
    } else {
      _isLoggedIn = false;
      _user = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final userData = await _authService.login(email, password);
    _user = userData;
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }
}
