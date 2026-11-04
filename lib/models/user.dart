// lib/models/user.dart

/// Utilisateur connecté, tel que renvoyé par l'API.
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int role;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });
  String get roleLabel {
    switch (role) {
      case 1:
        return 'Admin';
      case 2:
        return 'User';
      default:
        return 'Inconnu';
    }
  }

  /// Construit un utilisateur à partir de la réponse JSON de l'API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      role: json['role'] as int,
    );
  }
}
