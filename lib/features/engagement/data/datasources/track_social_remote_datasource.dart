import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../library/data/models/paginated_tracks_model.dart';
import '../models/paginated_engagers_model.dart';

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

  Future<PaginatedTracksModel> getLikedTracks({
    int page = 0,
    int size = 10,
  }) async {
    final userId = await _resolveCurrentUserId();
    final endpoints = <String>[
      '/users/me/liked-tracks',
      '/users/me/likes',
      if (userId != null) '/users/$userId/likes',
      if (userId != null) '/users/$userId/liked-tracks',
    ];

    return _fetchTrackCollection(endpoints: endpoints, page: page, size: size);
  }

  Future<PaginatedTracksModel> getRepostedTracks({
    int page = 0,
    int size = 10,
  }) async {
    final userId = await _resolveCurrentUserId();
    final endpoints = <String>[
      '/users/me/repost',
      '/users/me/reposts',
      if (userId != null) '/users/$userId/repost',
      if (userId != null) '/users/$userId/reposts',
    ];

    return _fetchTrackCollection(endpoints: endpoints, page: page, size: size);
  }

  Future<PaginatedTracksModel> _fetchTrackCollection({
    required List<String> endpoints,
    required int page,
    required int size,
  }) async {
    DioException? lastDioException;

    for (final endpoint in endpoints) {
      try {
        final response = await _dioClient.get<Map<String, dynamic>>(
          endpoint,
          queryParams: {'page': page, 'size': size},
        );

        final data = response.data;
        if (data == null) {
          throw const ServerException('No data returned from server.');
        }

        return PaginatedTracksModel.fromJson(data);
      } on DioException catch (error) {
        lastDioException = error;
        final statusCode = error.response?.statusCode;

        // Continue trying alternative endpoint shapes for path mismatches.
        if (statusCode == 404 || statusCode == 405) {
          continue;
        }

        throw _handleDioError(error);
      }
    }

    if (lastDioException != null) {
      throw _handleDioError(lastDioException);
    }

    throw const ServerException('No track collection endpoint succeeded.');
  }

  Future<int?> _resolveCurrentUserId() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('/users/me');
      final body = response.data;
      if (body == null) {
        return null;
      }

      final data = body['data'];
      final payload = data is Map<String, dynamic> ? data : body;
      final profile = payload['profile'];
      final profileMap = profile is Map<String, dynamic>
          ? profile
          : const <String, dynamic>{};

      final topLevelId = payload['id'];
      if (topLevelId is num) {
        return topLevelId.toInt();
      }

      final nestedId = profileMap['id'];
      if (nestedId is num) {
        return nestedId.toInt();
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> unrepostTrack(int trackId) async {
    try {
      await _dioClient.delete<dynamic>('/tracks/$trackId/repost');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetches the paginated list of users who liked [trackId].
  Future<PaginatedEngagersModel> fetchTrackLikers({
    required int trackId,
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/tracks/$trackId/like',
        queryParams: {'page': page, 'size': size},
      );
      return PaginatedEngagersModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetches the paginated list of users who reposted [trackId].
  Future<PaginatedEngagersModel> fetchTrackReposters({
    required int trackId,
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/tracks/$trackId/reposters',
        queryParams: {'page': page, 'size': size},
      );
      return PaginatedEngagersModel.fromJson(response.data!);
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
