// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/responsive_content.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil de l\'Utilisateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Action de déconnexion
              Navigator.pop(context);
            },
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
              onPressed: () {
                // Déconnexion en retournant à l'écran de connexion
                Navigator.pop(context);
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
