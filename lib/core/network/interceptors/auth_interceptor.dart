import 'dart:async';
import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';
import '../../storage/secure_storage_service.dart';
import '../events/auth_event_bus.dart';

/// Intercepts network requests to attach JWT tokens and handle automatic token refreshing.
///
/// This interceptor performs three key tasks:
/// 1. Installs the `Authorization: Bearer <token>` header on all outgoing requests.
/// 2. Proactively checks if the token is expired (< 1m remaining) before sending
///    the request and triggers a refresh if needed.
/// 3. Reactively catches `401 Unauthorized` responses and attempts a single refresh and retry.
///
/// Uses a concurrency lock (`_refreshLock`) to ensure multiple simultaneous requests
/// do not trigger multiple concurrent refresh calls.
class AuthInterceptor extends Interceptor {
  /// Constructs the interceptor with the required secure storage service and optionally a custom
  /// Dio instance for the refresh call to prevent infinite interception loops.
  AuthInterceptor(this._secureStorage, {Dio? refreshDio})
    : _refreshDio =
          refreshDio ??
          (Dio()
            ..options.baseUrl = ApiConstants.baseUrl
            ..options.connectTimeout = const Duration(
              milliseconds: ApiConstants.connectTimeout,
            )
            ..options.receiveTimeout = const Duration(
              milliseconds: ApiConstants.receiveTimeout,
            ));

  final SecureStorageService _secureStorage;
  final Dio _refreshDio;

  // Concurrency lock for refresh requests
  Future<void>? _refreshLock;

  /// Endpoints that do not require authentication and should bypass
  /// proactive token refresh to avoid blocking on stale token refresh attempts.
  static const List<String> _publicEndpoints = [
    '/auth/login/local',
    '/auth/register/local',
    '/auth/oauth/google',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/auth/refreshtoken',
  ];

  /// Returns `true` if the request path matches a public endpoint that
  /// should not trigger proactive token refresh.
  bool _isPublicEndpoint(String path) {
    return _publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip proactive refresh and token attachment for public endpoints
    // (login, register, OAuth exchange, etc.) to avoid blocking on stale
    // token refresh attempts.
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // 1. Check proactive expiration before attaching.
    final isExpired = await _secureStorage.isAccessTokenExpired();

    if (isExpired) {
      try {
        await _refreshTokenIfNecessary();
      } catch (e) {
        // If proactive refresh fails, we still send the request (it might be public anyway)
        // or let it fail naturally and get caught by the onError handler.
      }
    }

    // 2. Attach the token
    final token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if the error is due to an invalid/expired token (401)
    if (err.response?.statusCode == 401) {
      try {
        await _refreshTokenIfNecessary();

        // If refresh successful, retry the original request
        final token = await _secureStorage.getAccessToken();

        // Final sanity check, though highly unlikely to be null if refresh succeeded
        if (token != null) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $token';

          // Create a new request based on the original request's options
          final response = await _refreshDio.fetch<dynamic>(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh completely failed. The user's session is dead.
        await _secureStorage.clearAll();
        AuthEventBus().emitLogout();
        // Fallthrough to reject the request
      }
    }

    return handler.next(err);
  }

  /// Handles the actual refresh logic, ensuring only one refresh runs at a time.
  Future<void> _refreshTokenIfNecessary() async {
    // If a refresh is already in progress, just await it.
    if (_refreshLock != null) {
      return _refreshLock;
    }

    // Set up a completer to act as our lock
    final completer = Completer<void>();
    _refreshLock = completer.future;

    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refreshtoken',
        data: {'refreshToken': refreshToken},
      );

      final responseBody = response.data;
      final dataPayload =
          responseBody?['data'] as Map<String, dynamic>? ?? responseBody;

      final newAccessToken = dataPayload?['accessToken'] as String?;
      final expiresIn = dataPayload?['expiresIn'] as int?;

      if (newAccessToken != null && expiresIn != null) {
        await _secureStorage.saveRefreshTokens(
          accessToken: newAccessToken,
          expiresIn: expiresIn,
          // No refreshToken — API does not rotate it on refresh.
        );
      } else {
        throw Exception('Invalid token response format');
      }

      completer.complete();
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      // Clear the lock so future requests can try again if they hit a 401 later
      // (though likely they will be logged out by now)
      _refreshLock = null;
    }
  }
}
