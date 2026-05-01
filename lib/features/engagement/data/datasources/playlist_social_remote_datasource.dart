import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../playlists/data/models/playlist_model.dart';

@injectable
class PlaylistSocialRemoteDatasource {
  PlaylistSocialRemoteDatasource(this._dioClient);
  final DioClient _dioClient;

  Future<bool> toggleLike(
    int playlistId, {
    required bool isCurrentlyLiked,
  }) async {
    try {
      if (isCurrentlyLiked) {
        await _dioClient.delete<dynamic>(
          ApiConstants.togglePlaylistLike(playlistId),
        );
        return false;
      } else {
        final response = await _dioClient.post<dynamic>(
          ApiConstants.togglePlaylistLike(playlistId),
        );

        final data = response.data;
        if (data is Map<String, dynamic>) {
          return data['isLiked'] as bool? ?? true;
        }
        return true;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<bool> toggleRepost(
    int playlistId, {
    required bool isCurrentlyReposted,
  }) async {
    try {
      final endpoint = ApiConstants.togglePlaylistRepost(playlistId);

      if (isCurrentlyReposted) {
        final response = await _dioClient.delete<dynamic>(endpoint);
        return _readRepostState(response.data, fallback: false);
      }

      final response = await _dioClient.post<dynamic>(endpoint);
      return _readRepostState(response.data, fallback: true);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  bool _readRepostState(Object? data, {required bool fallback}) {
    if (data is Map<String, dynamic>) {
      return data['isReposted'] as bool? ?? fallback;
    }

    return fallback;
  }

  Future<List<PlaylistModel>> getLikedPlaylists(
    String username, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final endpoint = ApiConstants.likedPlaylistsByUsername(username);

      final response = await _dioClient.get<dynamic>(
        endpoint,
        queryParams: {'page': page, 'size': size},
      );

      final data = response.data;

      if (data == null) {
        return [];
      }

      final contentList = _extractListPayload(data);

      return contentList.whereType<Map<Object?, Object?>>().map((json) {
        final cleanMap = Map<String, dynamic>.from(json);
        return PlaylistModel.fromJson(cleanMap);
      }).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (error, stackTrace) {
      debugPrint('==========PARSING CRASH: $error');
      debugPrint('==========STACKTRACE: $stackTrace');
      throw ServerException('Failed to parse liked playlists response: $error');
    }
  }

  List<Object?> _extractListPayload(Object? data) {
    if (data == null) {
      return const <Object?>[];
    }

    if (data is List<Object?>) {
      return data;
    }

    if (data is! Map<Object?, Object?>) {
      return const <Object?>[];
    }

    final dataMap = Map<String, dynamic>.from(data);
    final nested = dataMap['data'];
    if (nested is List<Object?>) {
      return nested;
    }

    if (nested is Map<Object?, Object?>) {
      final nestedContent = nested['content'];
      if (nestedContent is List<Object?>) {
        return nestedContent;
      }
    }

    final content = dataMap['content'];
    if (content is List<Object?>) {
      return content;
    }

    return const <Object?>[];
  }

  AppException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(
          'No internet connection. Please check your network and try again.',
        );

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
