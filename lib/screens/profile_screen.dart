// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/responsive_content.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  /// Service d'authentification, remplaçable dans les tests.
  final AuthService? authService;

  const ProfileScreen({super.key, required this.user, this.authService});

  // Supprime le token et retourne à l'écran de connexion
  Future<void> _logout(BuildContext context) async {
    final service = authService ?? AuthService();
    await service.logout();
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(authService: service),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil de l\'Utilisateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ResponsiveContent(
        child: Column(
          children: <Widget>[
            ProfileInfoTile(
              icon: Icons.person,
              label: 'Nom',
              value: '${user.firstName} ${user.lastName}',
            ),
            ProfileInfoTile(
              icon: Icons.email,
              label: 'Email',
              value: user.email,
            ),
            ProfileInfoTile(
              icon: Icons.security,
              label: 'Rôle',
              value: user.roleLabel,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
