/// Application-level exception with a user-safe message.
///
/// Messages must never expose passwords, tokens, payment secrets, or sensitive
/// customer information (Section 35).
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  AppException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  factory AppException.networkTimeout() => AppException(
        message: 'Connection timed out. Please check your internet and try again.',
      );

  factory AppException.noInternet() => AppException(
        message: 'No internet connection. Some content may be stale.',
      );

  factory AppException.apiError(int? statusCode, String? message) =>
      AppException(
        message: message ?? 'An error occurred. Please try again later.',
        statusCode: statusCode,
      );

  factory AppException.cancelled() => AppException(
        message: 'Request was cancelled.',
      );

  factory AppException.unknown(String? error) => AppException(
        message: 'An unexpected error occurred.',
        originalError: error,
      );

  @override
  String toString() => 'AppException: $message (status: $statusCode)';
}