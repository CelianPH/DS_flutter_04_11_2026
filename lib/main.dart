// lib/main.dart

import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  // Nécessaire pour lire le token stocké avant d'afficher le premier écran
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application de Connexion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
