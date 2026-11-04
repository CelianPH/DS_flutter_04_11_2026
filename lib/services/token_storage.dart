// lib/services/token_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Conserve le token d'authentification de manière sécurisée sur l'appareil.
class TokenStorage {
  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<String?> read() => _storage.read(key: _tokenKey);

  Future<void> save(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> delete() => _storage.delete(key: _tokenKey);
}
