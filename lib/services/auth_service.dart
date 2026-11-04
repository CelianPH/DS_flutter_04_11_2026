// lib/services/auth_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'api_config.dart';
import 'token_storage.dart';

/// Levée quand l'API est injoignable ou que sa réponse est inexploitable.
/// Ce cas est différent d'identifiants incorrects.
class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class AuthService {
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;
  final TokenStorage _tokenStorage;

  /// Le client et le stockage peuvent être remplacés dans les tests.
  AuthService({http.Client? client, TokenStorage? tokenStorage})
    : _client = client ?? http.Client(),
      _tokenStorage = tokenStorage ?? TokenStorage();

  /// Envoie les identifiants à l'API et conserve le token reçu.
  ///
  /// Renvoie l'utilisateur si la connexion réussit, `null` si les identifiants
  /// sont incorrects, et lève une [AuthException] en cas de problème technique.
  Future<User?> login(String email, String password) async {
    final response = await _send(
      () => _client.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        body: {'email': email, 'password': password},
      ),
    );

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      switch (data['status']) {
        case 200:
          final user = User.fromJson(data);
          await _saveToken(data['token'] as String);
          return user;
        case 400:
          return null;
        default:
          throw const AuthException('Erreur du serveur');
      }
    } on FormatException {
      throw const AuthException('Réponse du serveur invalide');
    } on TypeError {
      // Champ manquant ou de mauvais type dans le JSON.
      throw const AuthException('Réponse du serveur invalide');
    }
  }

  /// Retrouve l'utilisateur connecté grâce au token conservé.
  ///
  /// Renvoie `null` s'il faut se connecter : pas de token, token refusé par
  /// l'API (il est alors supprimé) ou API injoignable.
  Future<User?> restoreSession() async {
    try {
      final token = await _tokenStorage.read();
      if (token == null) return null;

      final response = await _send(
        () => _client.get(
          Uri.parse('${ApiConfig.baseUrl}/profile'),
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] == 200) return User.fromJson(data);
      if (data['status'] == 401) await _tokenStorage.delete();
      return null;
    } on Exception {
      return null;
    } on TypeError {
      return null;
    }
  }

  /// Déconnecte l'utilisateur en supprimant son token.
  Future<void> logout() => _tokenStorage.delete();

  /// Exécute une requête et traduit les problèmes réseau en [AuthException].
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException {
      throw const AuthException('Le serveur ne répond pas');
    } on Exception {
      // SocketException ou ClientException selon la plateforme.
      throw const AuthException('Impossible de joindre le serveur');
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      await _tokenStorage.save(token);
    } on Exception {
      throw const AuthException('Impossible d\'enregistrer la session');
    }
  }
}
