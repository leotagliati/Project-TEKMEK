import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class TokenStorageService {

  static final TokenStorageService _instance = TokenStorageService._internal();
  TokenStorageService._internal();
  factory TokenStorageService() {
    return _instance;
  }


  final _storage = const FlutterSecureStorage();

  /// A chave para salvar o token.
  static const _tokenKey = 'auth_token';

  /// Salva o token de autenticação
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Le o token de autenticação 
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Deleta o token de autenticação
  /// para log out
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}