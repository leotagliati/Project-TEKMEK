import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Um serviço Singleton que gerencia o armazenamento seguro do token JWT.
class TokenStorageService {
  // Configuração do Singleton
  static final TokenStorageService _instance = TokenStorageService._internal();
  TokenStorageService._internal();
  factory TokenStorageService() {
    return _instance;
  }

  /// A instância do plugin de armazenamento seguro.
  final _storage = const FlutterSecureStorage();

  /// A chave que usaremos para salvar o token.
  static const _tokenKey = 'auth_token';

  /// Salva o token de autenticação no armazenamento seguro.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Lê o token de autenticação do armazenamento seguro.
  /// Retorna `null` se o token não for encontrado.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Deleta o token de autenticação do armazenamento seguro.
  /// Usado durante o logout.
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}