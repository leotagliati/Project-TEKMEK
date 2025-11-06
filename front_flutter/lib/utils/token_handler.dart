// lib/utils/token_handler.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHandler {
  static final TokenHandler _instance = TokenHandler._internal();
  TokenHandler._internal();
  factory TokenHandler() {
    return _instance;
  }

  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}