import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/library_profile/data/models/public_profile_model.dart';
import '../models/follow_response_model.dart';

/// Contract for remote follow-related API calls.
///
/// Handles fetching public profiles and toggling the follow relationship
/// between the current user and another user.
abstract class IFollowRemoteDataSource {
  /// Fetches a public profile for the given [userId].
  ///
  /// Calls `GET /users/{userId}` and returns a [PublicProfileModel].
  Future<PublicProfileModel> getPublicProfile(int userId);

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
  Future<PublicProfileModel> getPublicProfile(int userId) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.publicProfile(userId),
      );

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ServerException('Received empty response from server');
      }

      // The response may be nested under a 'data' key or be top-level.
      final Map<String, dynamic> responseData = data['data'] != null
          ? data['data'] as Map<String, dynamic>
          : data;

      return PublicProfileModel.fromJson(responseData);
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

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ServerException('Empty follow response from server');
      }

      return FollowResponseModel.fromJson(data);
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

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ServerException('Empty unfollow response from server');
      }

      return FollowResponseModel.fromJson(data);
    } on DioException catch (e) {
      _handleDioError(e, 'unfollow');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error while unfollowing user: $e');
    }
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
