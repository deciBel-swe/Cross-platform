import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

@injectable
class TrackSocialRemoteDatasource {
  const TrackSocialRemoteDatasource(this._dioClient);
  final DioClient _dioClient;

  Future<void> likeTrack(int trackId) async {
    try {
      await _dioClient.post<dynamic>('/tracks/$trackId/like');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> unlikeTrack(int trackId) async {
    try {
      await _dioClient.delete<dynamic>('/tracks/$trackId/like');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> repostTrack(int trackId) async {
    try {
      await _dioClient.post<dynamic>('/tracks/$trackId/repost');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> unrepostTrack(int trackId) async {
    try {
      await _dioClient.delete<dynamic>('/tracks/$trackId/repost');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Maps a [DioException] to the appropriate [AppException] subclass.
  AppException _handleDioError(DioException e) {
    switch (e.type) {
      // No connectivity, DNS failure, or socket hang-up
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(
          'No internet connection. Please check your network and try again.',
        );

      // Server returned an HTTP error status
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final responseData = e.response?.data;
        final body = responseData is Map<String, dynamic> ? responseData : null;
        final serverMessage =
            body?['message'] as String? ?? body?['error'] as String?;

        return switch (status) {
          401 => const AuthException('Session expired. Please log in again.'),
          403 => const AuthException(
            'You do not have permission to perform this action.',
          ),
          404 => const ServerException(
            'This action is not supported (endpoint not found).',
          ),
          429 => const ServerException(
            'Too many requests. Please slow down and try again.',
          ),
          _ => ServerException(
            serverMessage ??
                'Server error${status != null ? ' ($status)' : ''}. Please try again later.',
          ),
        };

      // Request was cancelled (e.g. widget disposed before response)
      case DioExceptionType.cancel:
        return const ServerException('Request was cancelled.');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return ServerException(e.message ?? 'An unexpected error occurred.');
    }
  }
}
