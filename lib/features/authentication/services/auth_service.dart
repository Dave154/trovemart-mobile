import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/errors/app_exception.dart';
import 'package:trovemart_app/core/utilities/logger.dart';
import 'package:trovemart_app/features/authentication/models/user.dart';

/// Authentication service (mock implementation).
///
/// ⚠️ MOCK DATA ONLY — All methods simulate backend calls.
/// Replace with real API calls via ApiClient once backend auth contracts are
/// delivered (Section 32).
class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  User? _currentUser;
  String? _authToken;

  /// Simulated network delay for mock calls.
  static const Duration _delay = Duration(seconds: 2);

  /// Whether a user is currently signed in.
  bool get isAuthenticated => _currentUser != null && _authToken != null;

  /// The current authenticated user, if any.
  User? get currentUser => _currentUser;

  /// The current auth token, if any.
  String? get authToken => _authToken;

  /// Register a new customer (full name, email, phone, password).
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    AppLogger.i('AuthService.register: $email');
    await Future.delayed(_delay);

    // Mock validation
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      return AuthResult.failure('Please fill in all required fields.');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters.');
    }

    // Mock successful registration — email verification required.
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      isEmailVerified: false,
      profilePhotoUrl: null,
      createdAt: DateTime.now(),
    );
    _authToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    return AuthResult.success(_currentUser!);
  }

  /// Sign in with email and password.
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    AppLogger.i('AuthService.login: $email');
    await Future.delayed(_delay);

    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Please enter email and password.');
    }

    // Mock successful login.
    _currentUser = User.mock().copyWith(email: email);
    _authToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    return AuthResult.success(_currentUser!);
  }

  /// Sign in with Google.
  Future<AuthResult> signInWithGoogle() async {
    AppLogger.i('AuthService.signInWithGoogle');
    await Future.delayed(_delay);

    // Mock successful Google sign-in.
    _currentUser = const User(
      id: 'user_google_1',
      fullName: 'Google User',
      email: 'googleuser@example.com',
      phoneNumber: '+2348000000000',
      isEmailVerified: true,
      profilePhotoUrl: null,
      createdAt: DateTime(2024, 6, 1),
    );
    _authToken = 'mock_google_token_${DateTime.now().millisecondsSinceEpoch}';

    return AuthResult.success(_currentUser!);
  }

  /// Request a password reset email.
  Future<AuthResult> forgotPassword({required String email}) async {
    AppLogger.i('AuthService.forgotPassword: $email');
    await Future.delayed(_delay);

    if (email.isEmpty) {
      return AuthResult.failure('Please enter your email address.');
    }

    return AuthResult.success(_currentUser!);
  }

  /// Verify email with a verification link (mock).
  Future<AuthResult> verifyEmail({required String verificationToken}) async {
    AppLogger.i('AuthService.verifyEmail');
    await Future.delayed(_delay);

    if (_currentUser == null) {
      return AuthResult.failure('No active session found.');
    }

    _currentUser = User(
      id: _currentUser!.id,
      fullName: _currentUser!.fullName,
      email: _currentUser!.email,
      phoneNumber: _currentUser!.phoneNumber,
      isEmailVerified: true,
      profilePhotoUrl: _currentUser!.profilePhotoUrl,
      createdAt: _currentUser!.createdAt,
    );

    return AuthResult.success(_currentUser!);
  }

  /// Sign out the current user.
  Future<void> logout() async {
    AppLogger.i('AuthService.logout');
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authToken = null;
  }

  /// Resend email verification link.
  Future<AuthResult> resendVerificationEmail() async {
    AppLogger.i('AuthService.resendVerificationEmail');
    await Future.delayed(_delay);
    return AuthResult.success(_currentUser!);
  }
}

/// Provider for AuthService.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});