import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration loaded from `.env` at runtime.
///
/// Supports development, testing, and production environments. Production
/// secrets must never be embedded in the Flutter application — they are
/// supplied via environment variables at build time.
class EnvConfig {
  EnvConfig._();

  /// Whether the app is running in production mode.
  static bool get isProduction => environment == 'production';

  /// Whether the app is running in testing mode.
  static bool get isTesting => environment == 'testing';

  /// Whether the app is running in development mode.
  static bool get isDevelopment => environment == 'development';

  /// The current environment name (development, testing, production).
  static String get environment {
    return dotenv.env[AppConstants.envEnvironment] ?? 'development';
  }

  /// The base URL for the backend API.
  static String get baseUrl {
    return dotenv.env[AppConstants.envBaseUrl] ?? 'http://localhost:3000';
  }

  /// Load environment configuration. Must be called before any access.
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}