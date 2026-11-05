/// User model — mock data placeholder (Section 32).
///
/// Matches the expected backend auth contract shape. Actual fields will be
/// confirmed once backend API contracts are delivered.
class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isEmailVerified;
  final String? profilePhotoUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isEmailVerified,
    this.profilePhotoUrl,
    required this.createdAt,
  });

  /// Initials for avatar display (e.g., "JD").
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  factory User.mock() => const User(
        id: 'user_1',
        fullName: 'Tunde Adebayo',
        email: 'tunde@example.com',
        phoneNumber: '+2348012345678',
        isEmailVerified: true,
        profilePhotoUrl: null,
        createdAt: DateTime(2024, 1, 15),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && id == other.id;

  @override
  int get hashCode => id.hashCode;

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? isEmailVerified,
    String? profilePhotoUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Result of an authentication operation.
class AuthResult {
  final bool success;
  final User? user;
  final String? errorMessage;

  const AuthResult._({
    required this.success,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success(User user) => AuthResult._(
        success: true,
        user: user,
      );

  factory AuthResult.failure(String errorMessage) => AuthResult._(
        success: false,
        errorMessage: errorMessage,
      );
}

/// Authentication state.
enum AuthStatus { unauthenticated, authenticating, authenticated }