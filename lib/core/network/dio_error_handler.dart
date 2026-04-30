import 'dart:io';

import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

/// Centralized error handler for Dio exceptions.
class DioErrorHandler {
  DioErrorHandler._();

  /// Converts a [DioException] into an appropriate [AppException] subclass.
  static AppException handle(DioException error, {String fallback = 'Server error occurred'}) {
    if (isNetworkError(error)) {
      return const NetworkException('No internet connection');
    }

    final statusCode = error.response?.statusCode;

    // Check for specific backend errors, including HTTP 500
    if (statusCode != null && statusCode >= 500) {
      return ServerException(extractErrorMessage(error, fallback: fallback));
    }

    if (statusCode == 404) {
      return NotFoundException(extractErrorMessage(error, fallback: 'Requested resource not found'));
    }

    if (statusCode == 401 || statusCode == 403) {
      return AuthException(extractErrorMessage(error, fallback: 'Authentication failed'));
    }

    return ServerException(extractErrorMessage(error, fallback: fallback));
  }

  /// Determines if a [DioException] represents a network connectivity issue.
  static bool isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.type == DioExceptionType.unknown && error.error is SocketException);
  }

  /// Extracts a human-readable error message from the [DioException] response body.
  static String extractErrorMessage(DioException error, {required String fallback}) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final parsed = _parseErrorMap(data);
      if (parsed != null) return parsed;
    }

    final fallbackMessage = error.message?.trim();
    if (fallbackMessage != null && fallbackMessage.isNotEmpty) {
      return '$fallback: $fallbackMessage';
    }

    return fallback;
  }

  static String? _parseErrorMap(Map<String, dynamic> data) {
    final errors = data['errors'];
    if (errors is Map<String, dynamic>) {
      final List<String> fieldErrors = [];

      errors.forEach((key, value) {
        if (value is List) {
          fieldErrors.add(value.join('\n'));
        } else {
          fieldErrors.add(value.toString());
        }
      });

      if (fieldErrors.isNotEmpty) {
        return fieldErrors.join('\n');
      }
    }

    return _parseMessageFromMap(data);
  }

  static String? _parseMessageFromMap(Map<String, dynamic> data) {
    final messageData = data['message'];
    if (messageData is List && messageData.isNotEmpty) {
      return messageData.join('\n');
    }

    if (messageData is String && messageData.trim().isNotEmpty) {
      return messageData.trim();
    }

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      final nestedMessage = _parseMessageFromMap(nestedData);
      if (nestedMessage != null) {
        return nestedMessage;
      }
    }

    return null;
  }
}
