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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: Text(
                    '${user.firstName[0]}${user.lastName[0]}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                '${user.firstName} ${user.lastName}',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 24.0),
              ProfileInfoTile(
                icon: Icons.mail_outline,
                label: 'Email',
                value: user.email,
              ),
              ProfileInfoTile(
                icon: Icons.badge_outlined,
                label: 'Rôle',
                value: user.roleLabel,
              ),
              const SizedBox(height: 24.0),
              OutlinedButton(
                onPressed: () => _logout(context),
                child: const Text('Se déconnecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
