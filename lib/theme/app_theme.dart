// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

/// Thème de l'application : composants Material avec une couleur principale
/// et des champs et boutons de même hauteur.
class AppTheme {
  static const Color _seedColor = Color(0xFF1F6F78);
  static const double _buttonHeight = 48.0;

  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(_buttonHeight),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(_buttonHeight),
      ),
    ),
  );
}
