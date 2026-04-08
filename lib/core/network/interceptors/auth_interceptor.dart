import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
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
@lazySingleton
class AuthInterceptor extends Interceptor {
  /// Constructs the interceptor with the required secure storage service.
  ///
  /// A dedicated internal Dio instance is created for refresh calls to avoid
  /// interceptor recursion.
  AuthInterceptor(this._secureStorage)
    : _refreshDio = (Dio()
        ..options.baseUrl = ApiConstants.baseUrl
        ..options.connectTimeout = const Duration(
          milliseconds: ApiConstants.connectTimeout,
        )
        ..options.receiveTimeout = const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ));

  final SecureStorageService _secureStorage;
  final Dio _refreshDio;
  final Uri _apiBaseUri = Uri.parse(ApiConstants.baseUrl);

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

  bool _isApiRequest(RequestOptions options) {
    final requestUri = options.uri;

    return requestUri.host == _apiBaseUri.host &&
        requestUri.port == _apiBaseUri.port;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isApiRequest = _isApiRequest(options);

    if (!isApiRequest) {
      // External URLs (e.g. blob waveform files) must not receive app Bearer tokens.
      options.headers.remove('Authorization');
      return handler.next(options);
    }

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
    // Skip token refresh/retry flow for non-API hosts.
    if (!_isApiRequest(err.requestOptions)) {
      return handler.next(err);
    }

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

      final oldAccessToken = await _secureStorage.getAccessToken() ?? '';
      final cookieHeader = 'refreshToken=$refreshToken; accessToken=$oldAccessToken';

      debugPrint('[AuthInterceptor] Refreshing Token: POST /auth/refreshtoken');
      debugPrint('[AuthInterceptor] Request Headers: {Cookie: $cookieHeader}');
      debugPrint('[AuthInterceptor] Request Body: {refreshToken: $refreshToken}');

      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refreshtoken',
        data: {'refreshToken': refreshToken}, // Keep payload for backward compatibility
        options: Options(
          headers: {
            'Cookie': cookieHeader,
          },
        ),
      );

      debugPrint('[AuthInterceptor] Response Status: ${response.statusCode}');
      debugPrint('[AuthInterceptor] Response Headers: ${response.headers.map}');
      debugPrint('[AuthInterceptor] Response Body: ${response.data}');

      final responseBody = response.data;
      final dataPayload =
          responseBody?['data'] as Map<String, dynamic>? ?? responseBody;

      String? newAccessToken = dataPayload?['accessToken'] as String?;
      final expiresIn = dataPayload?['expiresIn'] as int? ?? 3600;

      String? newRefreshToken = dataPayload?['refreshToken'] as String?;
      
      final cookies = response.headers.map['set-cookie'] ?? <String>[];
      for (final cookie in cookies) {
        final parts = cookie.split(';');
        for (final part in parts) {
          final trimmed = part.trim();
          if (trimmed.startsWith('refreshToken=')) {
            newRefreshToken = trimmed.substring('refreshToken='.length);
          } else if (trimmed.startsWith('accessToken=')) {
            newAccessToken = trimmed.substring('accessToken='.length);
          }
        }
      }

      if (newAccessToken != null) {
        await _secureStorage.saveRefreshTokens(
          accessToken: newAccessToken,
          expiresIn: expiresIn,
          refreshToken: newRefreshToken,
        );
      } else {
        throw Exception('Invalid token response format: no access token');
      }

      completer.complete();
    } catch (e) {
      debugPrint('[AuthInterceptor] Refresh Error: $e');
      completer.completeError(e);
      rethrow;
    } finally {
      // Clear the lock so future requests can try again if they hit a 401 later
      // (though likely they will be logged out by now)
      _refreshLock = null;
    }
  }
}
