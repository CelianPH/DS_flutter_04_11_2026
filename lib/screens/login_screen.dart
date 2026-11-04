// lib/screens/login_screen.dart

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/email_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/password_field.dart';
import '../widgets/responsive_content.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.title = 'Page de Connexion',
    this.authService,
  });

  final String title;

  /// Service d'authentification, remplaçable dans les tests.
  final AuthService? authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final AuthService _authService = widget.authService ?? AuthService();

  bool _isLoading = false; // État de chargement

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Méthode de connexion
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        final user = await _authService.login(email, password);
        if (!mounted) return;

        if (user != null) {
          // Connexion réussie : on affiche le profil renvoyé par l'API
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(user: user, authService: _authService),
            ),
          );
        } else {
          // Identifiants refusés par l'API
          _showError('Email ou mot de passe incorrect');
        }
      } on AuthException catch (error) {
        // Problème technique : API éteinte, délai dépassé, réponse invalide...
        if (mounted) _showError(error.message);
      } finally {
        // Quoi qu'il arrive, le chargement s'arrête
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ResponsiveContent(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              EmailField(controller: _emailController),
              const SizedBox(height: 16.0),
              PasswordField(controller: _passwordController),
              const SizedBox(height: 24.0),
              // Bouton de Connexion ou Indicateur de Chargement
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Se connecter'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
