// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

/// Écran de démarrage : vérifie si une session est déjà ouverte, puis affiche
/// le profil ou l'écran de connexion.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.authService});

  /// Service d'authentification, remplaçable dans les tests.
  final AuthService? authService;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthService _authService = widget.authService ?? AuthService();

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  void _restoreSession() async {
    final user = await _authService.restoreSession();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => user != null
            ? ProfileScreen(user: user, authService: _authService)
            : LoginScreen(authService: _authService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
