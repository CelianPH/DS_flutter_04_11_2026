// lib/services/auth_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'api_config.dart';

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

  /// Le client peut être remplacé dans les tests pour simuler l'API.
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  /// Envoie les identifiants à l'API.
  ///
  /// Renvoie l'utilisateur si la connexion réussit, `null` si les identifiants
  /// sont incorrects, et lève une [AuthException] en cas de problème technique.
  Future<User?> login(String email, String password) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}/login'),
            body: {'email': email, 'password': password},
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const AuthException('Le serveur ne répond pas');
    } on Exception {
      // SocketException ou ClientException selon la plateforme.
      throw const AuthException('Impossible de joindre le serveur');
    }

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      switch (data['status']) {
        case 200:
          return User.fromJson(data);
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
}
