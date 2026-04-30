

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/network/dio_error_handler.dart';

void main() {
  group('DioErrorHandler', () {
    test('should return NetworkException for connection error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );

      final result = DioErrorHandler.handle(error);
      expect(result, isA<NetworkException>());
      expect(result.message, 'No internet connection');
    });

    test('should return ServerException for 500 error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          data: {'message': 'Internal Server Error'},
        ),
      );

      final result = DioErrorHandler.handle(error);
      expect(result, isA<ServerException>());
      expect(result.message, 'Internal Server Error');
    });

    test('should return NotFoundException for 404 error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ),
      );

      final result = DioErrorHandler.handle(error);
      expect(result, isA<NotFoundException>());
    });

    test('should return AuthException for 401 error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
        ),
      );

      final result = DioErrorHandler.handle(error);
      expect(result, isA<AuthException>());
    });
  });
}
