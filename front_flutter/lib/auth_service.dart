import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum UserRole { user, admin }

class AuthService with ChangeNotifier {
  bool _isLoggedIn = false;
  UserRole? _role;
  String _accountId = "";

  bool get isLoggedIn => _isLoggedIn;
  UserRole? get role => _role;
  String get accountId => _accountId;

  final String _apiBaseUrl = 'http://localhost:5315';

  // _authUser 
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$_apiBaseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        _isLoggedIn = true;
        _role = (responseData['isAdmin'] ?? false) ? UserRole.admin : UserRole.user;
        _accountId = responseData['idlogin']?.toString() ?? '';

        notifyListeners(); // AVISA O GO_ROUTER!
        return null; // Sucesso
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        return 'Login e/ou senha inválidos.';
      } else {
        return 'Erro ao logar.';
      }
    } catch (e) {
      debugPrint(e.toString());
      return 'Erro ao conectar ao servidor.';
    }
  }

  //signupUser 
  Future<String?> signupUser(String username, String password) async {
    final url = Uri.parse('$_apiBaseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'username': username,
          'password': password,
          'token': null, // Registrando como usuário normal
        }),
      );

      if (response.statusCode == 201) {
        return null; // Sucesso. Não faz login, só registra.
      } else if (response.statusCode == 409) {
        return 'Este usuário já existe.';
      } else {
        return 'Erro ao registrar.';
      }
    } catch (e) {
      debugPrint(e.toString());
      return 'Erro ao conectar ao servidor.';
    }
  }

  //  recoverPassword
  Future<String?> recoverPassword(String name) async {
    final url = Uri.parse('$_apiBaseUrl/recover-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'username': name}),
      );

      if (response.statusCode == 200) {
        return null; // Sucesso
      } else if (response.statusCode == 404) {
        return 'Usuário não existe.';
      } else {
        return 'Erro no servidor.';
      }
    } catch (e) {
      debugPrint(e.toString());
      return 'Erro ao conectar ao servidor.';
    }
  }

  // Função de Logout
  void logout() {
    _isLoggedIn = false;
    _role = null;
    _accountId = "";
    notifyListeners(); // AVISA O GO_ROUTER!
  }
}