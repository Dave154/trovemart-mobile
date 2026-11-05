import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/constants/app_constants.dart';
import 'package:trovemart_app/core/storage/local_storage.dart';
import 'package:trovemart_app/features/authentication/models/user.dart';
import 'package:trovemart_app/features/authentication/services/auth_service.dart';

/// Authentication state notifier.
///
/// Manages sign-in / sign-out state and persists the auth token locally.
/// (Section 13: customers must register or sign in before purchasing;
/// guests may browse only.)
class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier(this._authService) : super(AuthStatus.unauthenticated) {
    _checkAuthState();
  }

  final AuthService _authService;

  /// Check for an existing session on startup.
  Future<void> _checkAuthState() async {
    final token = LocalStorage.getAuthToken();
    if (token != null && token.isNotEmpty) {
      state = AuthStatus.authenticated;
    }
  }

  /// Register a new customer.
  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    state = AuthStatus.authenticating;
    final result = await _authService.register(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );

    if (result.success && result.user != null) {
      await _persistSession(result.user!);
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
      throw AppException.apiError(null, result.errorMessage);
    }
  }

  /// Sign in with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthStatus.authenticating;
    final result = await _authService.login(email: email, password: password);

    if (result.success && result.user != null) {
      await _persistSession(result.user!);
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
      throw AppException.apiError(null, result.errorMessage);
    }
  }

  /// Sign in with Google.
  Future<void> signInWithGoogle() async {
    state = AuthStatus.authenticating;
    final result = await _authService.signInWithGoogle();

    if (result.success && result.user != null) {
      await _persistSession(result.user!);
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
      throw AppException.apiError(null, result.errorMessage);
    }
  }

  /// Sign out the current user.
  Future<void> logout() async {
    state = AuthStatus.authenticating;
    await _authService.logout();
    await LocalStorage.clearAuthToken();
    await LocalStorage.setUserId('');
    state = AuthStatus.unauthenticated;
  }

  /// Request a password reset email.
  Future<void> forgotPassword({required String email}) async {
    state = AuthStatus.authenticating;
    final result = await _authService.forgotPassword(email: email);
    state = AuthStatus.unauthenticated;
    if (!result.success) {
      throw AppException.apiError(null, result.errorMessage);
    }
  }

  /// Verify email with a verification token.
  Future<void> verifyEmail({required String verificationToken}) async {
    state = AuthStatus.authenticating;
    final result = await _authService.verifyEmail(
      verificationToken: verificationToken,
    );
    if (result.success && result.user != null) {
      await _persistSession(result.user!);
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
      throw AppException.apiError(null, result.errorMessage);
    }
  }

  Future<void> _persistSession(User user) async {
    await LocalStorage.setAuthToken(_authService.authToken!);
    await LocalStorage.setUserId(user.id);
  }
}

/// Provider for auth state.
final authProvider = StateNotifierProvider<AuthNotifier, AuthStatus>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

/// Provider for the current user (read-only).
final currentUserProvider = Provider<User?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.currentUser;
});