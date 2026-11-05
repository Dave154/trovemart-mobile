import 'package:dio/dio.dart';
import 'package:trovemart_app/core/constants/app_constants.dart';
import 'package:trovemart_app/core/constants/env_config.dart';
import 'package:trovemart_app/core/errors/app_exception.dart';

/// Centralised API client for all backend communication.
///
/// Expected flow (Section 31):
///   UI → State Management → Feature Service → ApiClient → Backend API
///
/// Screens must never make HTTP requests directly — they go through feature
/// services which use this client.
class ApiClient {
  ApiClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// The Dio instance used by feature services.
  static Dio get dio => _dio;

  /// Sets the auth token on all outgoing requests.
  static void setAuthToken(String? token) {
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Clears the auth token (used on logout).
  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Converts a Dio error into an [AppException] with a user-safe message.
  /// Never exposes tokens or secrets in the message.
  static AppException handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException.networkTimeout();
      case DioExceptionType.connectionError:
        return AppException.noInternet();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractMessage(error.response);
        return AppException.apiError(statusCode, message);
      case DioExceptionType.cancel:
        return AppException.cancelled();
      default:
        return AppException.unknown(error.toString());
    }
  }

  static String? _extractMessage(Response<dynamic>? response) {
    if (response == null) return null;
    final data = response.data;
    if (data is Map) {
      return data['message'] as String? ?? data['error'] as String?;
    }
    return null;
  }
}