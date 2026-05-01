import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../library/data/models/paginated_tracks_model.dart';
import '../models/paginated_engagers_model.dart';
import '../models/repost_history_model.dart';

@injectable
class TrackSocialRemoteDatasource {
  TrackSocialRemoteDatasource(this._dioClient);
  final DioClient _dioClient;

  int? _cachedCurrentUserId;
  Future<int?>? _currentUserIdInFlight;
  String? _cachedLikedMeEndpoint;
  String? _cachedRepostedMeEndpoint;

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
    int? userId,
    String? username,
  }) async {
    final publicUsername = _normalizeUsername(username);
    final meEndpoints = <String>[
      if (publicUsername != null)
        ApiConstants.likedTracksByUsername(publicUsername),
      if (publicUsername == null &&
          userId == null &&
          _cachedLikedMeEndpoint != null)
        _cachedLikedMeEndpoint!,
      if (publicUsername == null && userId == null) '/users/me/liked-tracks',
      if (publicUsername == null && userId != null)
        '/users/$userId/liked-tracks',
    ];

    final firstPass = _uniqueEndpoints(meEndpoints);
    try {
      return await _fetchTrackCollection(
        endpoints: firstPass,
        page: page,
        size: size,
        onSuccess: (endpoint) {
          if (publicUsername == null &&
              userId == null &&
              endpoint.startsWith('/users/me/')) {
            _cachedLikedMeEndpoint = endpoint;
          }
        },
      );
    } on AppException catch (error) {
      if (error is NetworkException) {
        rethrow;
      }

      final resolvedUserId = userId ?? await _resolveCurrentUserId();
      final fallbackEndpoints = <String>[
        if (publicUsername != null)
          ApiConstants.likedTracksByUsername(publicUsername),
        if (publicUsername == null && resolvedUserId != null)
          '/users/$resolvedUserId/liked-tracks',
      ];

      return _fetchTrackCollection(
        endpoints: _uniqueEndpoints(fallbackEndpoints),
        page: page,
        size: size,
      );
    }
  }

  Future<PaginatedTracksModel> getRepostedTracks({
    int page = 0,
    int size = 10,
    int? userId,
    String? username,
  }) async {
    final publicUsername = _normalizeUsername(username);
    final meEndpoints = <String>[
      if (publicUsername != null)
        ApiConstants.repostedTracksByUsername(publicUsername),
      if (publicUsername == null &&
          userId == null &&
          _cachedRepostedMeEndpoint != null)
        _cachedRepostedMeEndpoint!,
      if (publicUsername == null && userId == null) '/users/me/repost',
      if (publicUsername == null && userId != null)
        '/users/$userId/reposted-tracks',
      if (publicUsername == null && userId != null) '/users/$userId/repost',
    ];

    final firstPass = _uniqueEndpoints(meEndpoints);
    try {
      return await _fetchTrackCollection(
        endpoints: firstPass,
        page: page,
        size: size,
        onSuccess: (endpoint) {
          if (publicUsername == null &&
              userId == null &&
              endpoint.startsWith('/users/me/')) {
            _cachedRepostedMeEndpoint = endpoint;
          }
        },
      );
    } on AppException catch (error) {
      if (error is NetworkException) {
        rethrow;
      }

      final resolvedUserId = userId ?? await _resolveCurrentUserId();
      final fallbackEndpoints = <String>[
        if (publicUsername != null)
          ApiConstants.repostedTracksByUsername(publicUsername),
        if (publicUsername == null && resolvedUserId != null)
          '/users/$resolvedUserId/reposted-tracks',
        if (publicUsername == null && resolvedUserId != null)
          '/users/$resolvedUserId/repost',
      ];

      return _fetchTrackCollection(
        endpoints: _uniqueEndpoints(fallbackEndpoints),
        page: page,
        size: size,
      );
    }
  }

  Future<PaginatedRepostHistoryModel> getRepostHistory(
    String username, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.repostHistoryByUsername(username),
        queryParams: {'page': page, 'size': size},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('No data returned from server.');
      }

      final payload = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      return PaginatedRepostHistoryModel.fromJson(
        _normalizePagination(payload),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<PaginatedTracksModel> _fetchTrackCollection({
    required List<String> endpoints,
    required int page,
    required int size,
    void Function(String endpoint)? onSuccess,
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

        onSuccess?.call(endpoint);

        return PaginatedTracksModel.fromJson(_normalizeTrackPage(data));
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

  String? _normalizeUsername(String? username) {
    final trimmed = username?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  List<String> _uniqueEndpoints(List<String> endpoints) {
    final seen = <String>{};
    final result = <String>[];
    for (final endpoint in endpoints) {
      if (seen.add(endpoint)) {
        result.add(endpoint);
      }
    }
    return result;
  }

  Future<int?> _resolveCurrentUserId() async {
    if (_cachedCurrentUserId != null) {
      return _cachedCurrentUserId;
    }

    final inFlight = _currentUserIdInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    _currentUserIdInFlight = _fetchCurrentUserId();
    final resolved = await _currentUserIdInFlight;
    _currentUserIdInFlight = null;

    if (resolved != null) {
      _cachedCurrentUserId = resolved;
    }

    return resolved;
  }

  Future<int?> _fetchCurrentUserId() async {
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

  Future<void> reportTrack({
    required int trackId,
    required String reason,
    String? description,
  }) async {
    try {
      final data = <String, dynamic>{'reason': reason};
      if (description != null) {
        data['description'] = description;
      }

      await _dioClient.post<dynamic>('/tracks/$trackId/report', data: data);
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
        '/users/tracks/$trackId/like',
        queryParams: {'page': page, 'size': size},
      );
      return PaginatedEngagersModel.fromJson(
        _normalizePagination(response.data!),
      );
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
        '/users/tracks/$trackId/reposters',
        queryParams: {'page': page, 'size': size},
      );
      return PaginatedEngagersModel.fromJson(
        _normalizePagination(response.data!),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Map<String, dynamic> _normalizePagination(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    if (!normalized.containsKey('pageNumber') &&
        normalized.containsKey('number')) {
      normalized['pageNumber'] = normalized['number'];
      normalized['pageSize'] = normalized['size'];
      normalized['isLast'] = normalized['last'];
    }

    if (normalized['content'] is List) {
      final content = normalized['content'] as List;
      normalized['content'] = content.map((item) {
        if (item is Map<String, dynamic>) {
          final normalizedItem = Map<String, dynamic>.from(item);
          // Handle flat structure
          if (!normalizedItem.containsKey('avatarUrl') &&
              normalizedItem.containsKey('profilePic')) {
            normalizedItem['avatarUrl'] = normalizedItem['profilePic'];
          }
          // Handle nested profile structure (OpenAPI spec shape)
          if (!normalizedItem.containsKey('avatarUrl') &&
              normalizedItem['profile'] is Map<String, dynamic>) {
            final profile = normalizedItem['profile'] as Map<String, dynamic>;
            if (profile.containsKey('avatarUrl')) {
              normalizedItem['avatarUrl'] = profile['avatarUrl'];
            }
          }
          return normalizedItem;
        }
        return item;
      }).toList();
    }

    return normalized;
  }

  Map<String, dynamic> _normalizeTrackPage(Map<String, dynamic> json) {
    final nestedData = json['data'];
    final source = nestedData is Map<String, dynamic> ? nestedData : json;
    final normalized = Map<String, dynamic>.from(source);

    normalized['pageNumber'] ??= normalized['number'] ?? 0;
    normalized['pageSize'] ??= normalized['size'] ?? 0;
    normalized['totalElements'] ??=
        (normalized['content'] as List?)?.length ?? 0;
    normalized['totalPages'] ??= 1;
    normalized['isLast'] ??= normalized['last'] ?? true;

    return normalized;
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

      case DioExceptionType.badCertificate:
        return ServerException(e.message ?? 'An unexpected error occurred.');
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NetworkException(
            'No internet connection. Please check your network and try again.',
          );
        }
        return ServerException(e.message ?? 'An unexpected error occurred.');
    }
  }
}
