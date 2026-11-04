// lib/services/api_config.dart

import 'package:flutter/foundation.dart';

/// Adresse de l'API locale.
class ApiConfig {
  /// Permet de changer l'adresse au lancement :
  /// flutter run --dart-define=API_BASE_URL=https://192.168.1.10:3000
  static const String _customBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_customBaseUrl.isNotEmpty) {
      return _customBaseUrl;
    }
    // Dans l'émulateur Android, 10.0.2.2 désigne le PC qui l'héberge.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'https://10.0.2.2:3000';
    }
    return 'https://127.0.0.1:3000';
  }
}
