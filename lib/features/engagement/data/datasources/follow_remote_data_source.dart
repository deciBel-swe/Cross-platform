import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/library_profile/data/models/public_profile_model.dart';
import '../models/follow_response_model.dart';
import '../models/paginated_engagers_model.dart';

/// Contract for remote follow-related API calls.
///
/// Handles fetching public profiles and toggling the follow relationship
/// between the current user and another user.
abstract class IFollowRemoteDataSource {
  /// Fetches a public profile for the given [userIdentifier].
  ///
  /// Calls `GET /users/{identifier}` and returns a [PublicProfileModel].
  Future<PublicProfileModel> getPublicProfile(String userIdentifier);

  /// Follows the user identified by [userId].
  ///
  /// Calls `POST /users/{userId}/follow` with an empty body.
  /// Returns the server-confirmed [FollowResponseModel].
  Future<FollowResponseModel> followUser(int userId);

  /// Unfollows the user identified by [userId].
  ///
  /// Calls `DELETE /users/{userId}/follow`.
  /// Returns the server-confirmed [FollowResponseModel].
  Future<FollowResponseModel> unfollowUser(int userId);

  /// Fetches paginated followers for [userId].
  Future<PaginatedEngagersModel> getFollowers({
    required int userId,
    required int page,
    required int size,
  });

  /// Fetches paginated following for [userId].
  Future<PaginatedEngagersModel> getFollowing({
    required int userId,
    required int page,
    required int size,
  });

  /// Fetches paginated suggested users for current user.
  Future<PaginatedEngagersModel> getSuggestedUsers({
    required int page,
    required int size,
  });

  /// Fetches paginated mutual followers (friends) for current user.
  Future<PaginatedEngagersModel> getFriends({
    required int page,
    required int size,
  });
}

/// Concrete implementation of [IFollowRemoteDataSource] using [DioClient].
///
/// Registered as a lazy singleton through Injectable so it can be injected
/// into [FollowRepositoryImpl].
@LazySingleton(as: IFollowRemoteDataSource)
class FollowRemoteDataSource implements IFollowRemoteDataSource {
  const FollowRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<PublicProfileModel> getPublicProfile(String userIdentifier) async {
    try {
      final trimmedIdentifier = userIdentifier.trim();
      final endpoint = ApiConstants.publicProfile(trimmedIdentifier);

      final response = await _dioClient.get<dynamic>(endpoint);

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ServerException('Received empty response from server');
      }

      // The response may be nested under `data` and/or `profile`.
      final responseData = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      return PublicProfileModel.fromJson(_normalizePublicProfile(responseData));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Unauthorized. Please log in again.');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('User not found.');
      }
      throw ServerException(e.message ?? 'Unknown server error');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to parse public profile data: $e');
    }
  }

  @override
  Future<FollowResponseModel> followUser(int userId) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiConstants.followUser(userId),
        data: <String, dynamic>{},
      );

      return _parseFollowResponse(
        payload: response.data,
        expectedFollowing: true,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'follow');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error while following user: $e');
    }
  }

  @override
  Future<FollowResponseModel> unfollowUser(int userId) async {
    try {
      final response = await _dioClient.delete<dynamic>(
        ApiConstants.followUser(userId),
      );

      return _parseFollowResponse(
        payload: response.data,
        expectedFollowing: false,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'unfollow');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error while unfollowing user: $e');
    }
  }

  @override
  Future<PaginatedEngagersModel> getFollowers({
    required int userId,
    required int page,
    required int size,
  }) async {
    return _fetchPaginatedUsers(
      path: '/users/$userId/followers',
      page: page,
      size: size,
    );
  }

  @override
  Future<PaginatedEngagersModel> getFollowing({
    required int userId,
    required int page,
    required int size,
  }) async {
    return _fetchPaginatedUsers(
      path: '/users/$userId/following',
      page: page,
      size: size,
    );
  }

  @override
  Future<PaginatedEngagersModel> getSuggestedUsers({
    required int page,
    required int size,
  }) async {
    return _fetchSuggestedUsers(limit: size);
  }

  @override
  Future<PaginatedEngagersModel> getFriends({
    required int page,
    required int size,
  }) async {
    return _fetchPaginatedUsers(
      path: '/users/me/friends',
      page: page,
      size: size,
    );
  }

  Future<PaginatedEngagersModel> _fetchSuggestedUsers({
    required int limit,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        '/users/suggested',
        queryParams: <String, dynamic>{'limit': limit},
      );

      final body = response.data;

      if (body is List) {
        final users = body
            .whereType<Map<String, dynamic>>()
            .map(_normalizeUserItem)
            .toList();

        return PaginatedEngagersModel.fromJson(<String, dynamic>{
          'content': users,
          'pageNumber': 0,
          'pageSize': users.length,
          'totalElements': users.length,
          'totalPages': 1,
          'isLast': true,
        });
      }

      // Fallback for wrapped array responses: { data: [...] }
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is List) {
          final users = data
              .whereType<Map<String, dynamic>>()
              .map(_normalizeUserItem)
              .toList();

          return PaginatedEngagersModel.fromJson(<String, dynamic>{
            'content': users,
            'pageNumber': 0,
            'pageSize': users.length,
            'totalElements': users.length,
            'totalPages': 1,
            'isLast': true,
          });
        }

        // Last fallback if backend returns paginated map shape.
        final payload = data is Map<String, dynamic> ? data : body;
        final normalized = _normalizePaginatedUsers(payload);
        return PaginatedEngagersModel.fromJson(normalized);
      }

      throw const ServerException('Unexpected suggested users response shape');
    } on DioException catch (e) {
      _handleDioError(e, 'fetch suggested users');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to parse suggested users: $e');
    }
  }

  Future<PaginatedEngagersModel> _fetchPaginatedUsers({
    required String path,
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        path,
        queryParams: <String, dynamic>{'page': page, 'size': size},
      );

      final body = response.data;
      final data = body is Map<String, dynamic> ? body : <String, dynamic>{};
      final payload = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      final normalized = _normalizePaginatedUsers(payload);
      return PaginatedEngagersModel.fromJson(normalized);
    } on DioException catch (e) {
      _handleDioError(e, 'fetch users');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to parse paginated users: $e');
    }
  }

  Map<String, dynamic> _normalizePaginatedUsers(Map<String, dynamic> payload) {
    final rawContent =
        payload['content'] ?? payload['users'] ?? payload['items'];

    final listSource = rawContent is List
        ? rawContent
        : (payload['data'] is List
              ? payload['data'] as List
              : const <dynamic>[]);

    final contentList = listSource;

    final pageNumber = _asInt(payload['pageNumber'] ?? payload['page']) ?? 0;
    final pageSize =
        _asInt(payload['pageSize'] ?? payload['size']) ??
        (contentList.isEmpty ? 20 : contentList.length);
    final totalElements =
        _asInt(payload['totalElements'] ?? payload['total']) ??
        contentList.length;
    final totalPages = _asInt(payload['totalPages']) ?? 1;
    final isLast = _asBool(payload['isLast']) ?? (pageNumber + 1 >= totalPages);

    return <String, dynamic>{
      'content': contentList
          .whereType<Map<String, dynamic>>()
          .map(_normalizeUserItem)
          .toList(),
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'isLast': isLast,
    };
  }

  Map<String, dynamic> _normalizePublicProfile(Map<String, dynamic> payload) {
    final profile = payload['profile'] is Map<String, dynamic>
        ? payload['profile'] as Map<String, dynamic>
        : payload;
    final relationship = payload['relationship'] is Map<String, dynamic>
        ? payload['relationship'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final rawSocial =
        profile['socialLinks'] ??
        profile['socialLinksDto'] ??
        const <String, dynamic>{};
    final social = _normalizeSocialLinks(rawSocial);

    final city = (profile['city'] ?? '').toString().trim();
    final country = (profile['country'] ?? '').toString().trim();
    final location = switch ((city.isNotEmpty, country.isNotEmpty)) {
      (true, true) => '$city, $country',
      (true, false) => city,
      (false, true) => country,
      (false, false) => '',
    };

    final isFollowing =
        _asBool(
          payload['isFollowed'] ??
              relationship['isFollowed'] ??
              profile['isFollowed'] ??
              payload['isFollowingByCurrentUser'] ??
              relationship['isFollowingByCurrentUser'] ??
              profile['isFollowingByCurrentUser'] ??
              payload['isFollowing'] ??
              relationship['isFollowing'] ??
              profile['isFollowing'] ??
              payload['following'] ??
              relationship['following'] ??
              profile['following'],
        ) ??
        false;

    final isFollowedBy =
        _asBool(
          payload['isFollowedBy'] ??
              relationship['isFollowedBy'] ??
              profile['isFollowedBy'] ??
              payload['isFollowing'] ??
              relationship['isFollowing'] ??
              profile['isFollowing'] ??
              payload['isFollower'] ??
              payload['followsMe'] ??
              payload['isFollowingMe'] ??
              payload['followsCurrentUser'] ??
              payload['followingCurrentUser'] ??
              relationship['isFollower'] ??
              relationship['followsMe'] ??
              relationship['isFollowingMe'] ??
              relationship['followsCurrentUser'] ??
              relationship['followingCurrentUser'] ??
              profile['isFollower'] ??
              profile['followsMe'] ??
              profile['isFollowingMe'] ??
              profile['followsCurrentUser'] ??
              profile['followingCurrentUser'],
        ) ??
        false;

    final isBlocked =
        _asBool(
          payload['isBlocked'] ??
              relationship['isBlocked'] ??
              profile['isBlocked'],
        ) ??
        false;

    return <String, dynamic>{
      'id': _asInt(profile['id']) ?? 0,
      'username': (profile['username'] ?? '').toString(),
      'tier': (profile['tier'] ?? 'FREE').toString(),
      'profile': <String, dynamic>{
        'bio': profile['bio']?.toString(),
        'Location': location,
        'avatarUrl': profile['profilePic']?.toString(),
        'coverPhotoUrl': profile['coverPic']?.toString(),
        'favoriteGenres': profile['favoriteGenres'] is List
            ? profile['favoriteGenres']
            : const <dynamic>[],
      },
      'socialLinks': social,
      'stats': <String, dynamic>{
        'followersCount':
            _asInt(profile['followersCount'] ?? profile['followerCount']) ?? 0,
        'followingCount': _asInt(profile['followingCount']) ?? 0,
        'trackCount': _asInt(profile['trackCount']) ?? 0,
      },
      'isFollowing': isFollowing,
      'isFollowedBy': isFollowedBy,
      'isBlocked': isBlocked,
    };
  }

  Map<String, dynamic> _normalizeSocialLinks(Object? raw) {
    if (raw is Map<String, dynamic>) {
      return raw;
    }

    if (raw is List) {
      final maps = raw.whereType<Map<String, dynamic>>();
      if (maps.isNotEmpty) {
        return maps.first;
      }
    }

    return const <String, dynamic>{};
  }

  FollowResponseModel _parseFollowResponse({
    required Object? payload,
    required bool expectedFollowing,
  }) {
    if (payload is Map<String, dynamic>) {
      final isFollowing = _asBool(payload['isFollowing']) ?? expectedFollowing;
      final message =
          payload['message']?.toString() ??
          (isFollowing ? 'Followed successfully' : 'Unfollowed successfully');

      return FollowResponseModel(message: message, isFollowing: isFollowing);
    }

    // Backend may return empty body, primitive body, or just a count.
    return FollowResponseModel(
      message: expectedFollowing
          ? 'Followed successfully'
          : 'Unfollowed successfully',
      isFollowing: expectedFollowing,
    );
  }

  Map<String, dynamic> _normalizeUserItem(Map<String, dynamic> user) {
    final profile = user['profile'] is Map<String, dynamic>
        ? user['profile'] as Map<String, dynamic>
        : user;

    final id = _asInt(profile['id'] ?? user['id']) ?? 0;
    final username =
        (profile['username'] ??
                user['username'] ??
                user['userName'] ??
                user['displayName'] ??
                '')
            .toString();
    final avatarUrl =
        (profile['avatarUrl'] ??
                profile['profilePic'] ??
                user['avatarUrl'] ??
                user['profilePic'] ??
                user['avatar'])
            ?.toString();

    final rawTier = profile['tier'] ?? user['tier'];
    final tier = rawTier is String
        ? rawTier
        : (rawTier is Map<String, dynamic>
              ? (rawTier['name']?.toString() ?? 'FREE')
              : 'FREE');

    final isFollowing =
        _asBool(
          user['isFollowed'] ??
              profile['isFollowed'] ??
              user['isFollowingByCurrentUser'] ??
              profile['isFollowingByCurrentUser'] ??
              user['isFollowing'] ??
              profile['isFollowing'] ??
              user['following'] ??
              profile['following'],
        ) ??
        false;

    return <String, dynamic>{
      'id': id,
      'username': username,
      'avatarUrl': avatarUrl,
      'tier': tier,
      'isFollowing': isFollowing,
    };
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  bool? _asBool(Object? value) {
    if (value is bool) return value;
    final raw = value?.toString().toLowerCase();
    if (raw == 'true') return true;
    if (raw == 'false') return false;
    return null;
  }

  /// Translates common [DioException] status codes into typed [AppException]s.
  Never _handleDioError(DioException e, String action) {
    if (e.response?.statusCode == 401) {
      throw const AuthException('Unauthorized. Please log in again.');
    } else if (e.response?.statusCode == 404) {
      throw const ServerException('User not found.');
    }

    final responseData = e.response?.data;
    final backendMessage = responseData is Map<String, dynamic>
        ? responseData['message'] as String?
        : null;

    throw ServerException(
      backendMessage ?? e.message ?? 'Failed to $action user',
    );
  }
}
