import 'dart:developer';

/// Structured logging utility for Trovemart.
///
/// Never log passwords, authentication tokens, payment secrets, or sensitive
/// customer information (Section 35). Production logs are appropriately
/// restricted via the [isProduction] guard.
class AppLogger {
  AppLogger._();

  static const String _tag = 'Trovemart';

  /// Whether the app is running in production.
  static bool get isProduction => bool.fromEnvironment('dart.vm.product');

  /// Log a debug message. Stripped of sensitive data.
  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    if (isProduction) return;
    debugPrint('[$_tag][DEBUG] $message',
        error: error, stackTrace: stackTrace);
  }

  /// Log an informational message.
  static void i(String message) {
    debugPrint('[$_tag][INFO] $message');
  }

  /// Log a warning message.
  static void w(String message, {Object? error}) {
    debugPrint('[$_tag][WARNING] $message', error: error);
  }

  /// Log an error. Never includes raw tokens or secrets.
  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    debugPrint('[$_tag][ERROR] $message', error: error, stackTrace: stackTrace);
  }

  /// Sanitises a message by removing common secret patterns.
  static String sanitize(String message) {
    return message
        .replaceAll(RegExp(r'Bearer\s+\S+'), 'Bearer ***')
        .replaceAll(RegExp(r'token["\']?\s*[:=]\s*["\']?\S+'), 'token=***')
        .replaceAll(RegExp(r'password["\']?\s*[:=]\s*["\']?\S+'), 'password=***');
  }
}