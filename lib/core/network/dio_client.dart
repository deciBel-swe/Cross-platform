import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';

/// Centralized HTTP client wrapper around [Dio] for the Decibel application.
///
/// This client comes pre-configured with base URLs, timeouts, and required
/// interceptors such as [AuthInterceptor] for JWT handling and [LogInterceptor]
/// for debugging.
@lazySingleton
class DioClient {
  /// Constructs the client, attaching the [AuthInterceptor] if provided.
  ///
  /// The [AuthInterceptor] can be null if running in a mocked environment
  /// where token injection and refreshing are not applicable.
  DioClient(this._dio, {AuthInterceptor? authInterceptor}) {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = const Duration(
        milliseconds: ApiConstants.connectTimeout,
      )
      ..receiveTimeout = const Duration(
        milliseconds: ApiConstants.receiveTimeout,
      )
      ..contentType = 'application/json';

    if (authInterceptor != null) {
      _dio.interceptors.add(authInterceptor);
    }

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }
  final Dio _dio;

  // Helper method for GET requests
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams}) {
    return _dio.get(path, queryParameters: queryParams);
  }

  // Helper method for POST requestsD
  Future<Response<T>> post<T>(String path, {Object? data, Options? options}) {
    return _dio.post(path, data: data, options: options);
  }

  // Helper method for PUT requests
  Future<Response<T>> put<T>(String path, {Object? data}) {
    return _dio.put(path, data: data);
  }

  Future<Response<T>> patch<T>(String path, {Object? data}) {
    return _dio.patch(path, data: data);
  }

  // Helper method for DELETE requests
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParams,
  }) {
    return _dio.delete(path, queryParameters: queryParams);
  }
}
