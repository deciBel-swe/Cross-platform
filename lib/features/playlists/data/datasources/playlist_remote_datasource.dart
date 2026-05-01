import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Required for kDebugMode and debugPrint
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/create_playlist_request.dart';
import '../models/playlist_model.dart';

abstract class IPlaylistRemoteDataSource {
  Future<PlaylistModel> getPlaylistDetails(int playlistId);

  Future<List<PlaylistModel>> getUserPlaylists({
    int page = 0,
    int size = 20,
    int? userId,
    String? username,
  });

  Future<PlaylistModel> reorderTracks(int playlistId, List<int> trackIds);

  Future<PlaylistModel> createPlaylist(
    CreatePlaylistRequest request,
    File? coverImage,
  );

  Future<String> getPlaylistSecretLink(int playlistId);

  Future<PlaylistModel> updatePlaylist(
    int playListId,
    CreatePlaylistRequest request,
    File? coverImage,
  );
  Future<void> deletePlayList(int playListId);

  Future<void> addTrackToPlaylist(int playlistId, int trackId);
  Future<void> removeTrackFromPlaylist(int playlistId, int trackId);
}

@Injectable(as: IPlaylistRemoteDataSource)
class PlaylistRemoteDatasource implements IPlaylistRemoteDataSource {
  const PlaylistRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<String> getPlaylistSecretLink(int playlistId) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.getPlaylistSecretLink(playlistId),
      );

      final responseData = _extractObjectPayload(response.data);

      // check lowercase "secretLink" just in case your backend uses standard JSON camelCase.
      final secretLink =
          responseData['secretUrl'] ?? responseData['secretLink'];

      if (secretLink != null) {
        return secretLink as String;
      } else {
        throw const ServerException(
          'Secret link not found in response payload',
        );
      }
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(
        error.message ?? 'Failed to fetch playlist secret link',
      );
    } catch (error) {
      throw ServerException('Failed to parse secret link response: $error');
    }
  }

  @override
  Future<PlaylistModel> getPlaylistDetails(int playlistId) async {
    try {
      final response = await _dioClient.get<dynamic>(
        '${ApiConstants.playlists}/$playlistId',
      );

      final responseData = _extractObjectPayload(response.data);
      return PlaylistModel.fromJson(
        responseData,
      ); // Parses id, title, and the tracks array
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(error.message ?? 'Failed to fetch playlist tracks');
    }
  }

  @override
  Future<PlaylistModel> reorderTracks(
    int playlistId,
    List<int> trackIds,
  ) async {
    try {
      final response = await _dioClient.patch<dynamic>(
        ApiConstants.updateTracksOrder(playlistId),
        data: {"trackIds": trackIds},
      );

      final responseData = _extractObjectPayload(response.data);

      // The API returns the updated Playlist object
      return PlaylistModel.fromJson(responseData);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(error.message ?? 'Failed to reorder playlist');
    } catch (error) {
      throw ServerException(
        'Failed to parse reorder playlist response: $error',
      );
    }
  }

  @override
  Future<PlaylistModel> createPlaylist(
    CreatePlaylistRequest request,
    File? coverImage,
  ) async {
    try {
      final formData = await _buildPlaylistPayload(request, coverImage);

      final response = await _dioClient.post<dynamic>(
        ApiConstants.playlists,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType, // FORCES MULTIPART
        ),
      );
      final responseData = _extractObjectPayload(response.data);
      return PlaylistModel.fromJson(responseData);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(error.message ?? 'Failed to create playlist');
    } catch (error) {
      throw ServerException('Failed to parse create playlist response: $error');
    }
  }

  @override
  Future<List<PlaylistModel>> getUserPlaylists({
    int page = 0,
    int size = 20,
    int? userId,
    String? username,
  }) async {
    try {
      final publicUsername = username?.trim();
      final endpoint = publicUsername != null && publicUsername.isNotEmpty
          ? ApiConstants.userPublicPlaylistsByUsername(publicUsername)
          : userId != null
          ? ApiConstants.userPublicPlaylists(userId)
          : ApiConstants.myPlaylists;

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
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(error.message ?? 'Failed to fetch playlists');
    } catch (error) {
      throw ServerException('Failed to parse playlists response: $error');
    }
  }

  @override
  Future<PlaylistModel> updatePlaylist(
    int playListId,
    CreatePlaylistRequest request,
    File? coverImage,
  ) async {
    try {
      final formData = await _buildPlaylistPayload(request, coverImage);

      final response = await _dioClient.patch<dynamic>(
        '${ApiConstants.playlists}/$playListId',
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType, // FORCES MULTIPART
        ),
      );
      final responseData = _extractObjectPayload(response.data);
      return PlaylistModel.fromJson(responseData);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(error.message ?? 'Failed to update playlist');
    } catch (error) {
      throw ServerException('Failed to parse update playlist response: $error');
    }
  }

  @override
  Future<void> deletePlayList(int playListId) async {
    try {
      await _dioClient.delete<dynamic>(
        '${ApiConstants.playlists}/$playListId',
      ); // 204 no content
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(error.message ?? 'Failed to delete playlist');
    } catch (error) {
      throw ServerException(
        'Failed to execute delete playlist request: $error',
      );
    }
  }

  @override
  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    try {
      await _dioClient.post<Map<String, dynamic>>(
        '${ApiConstants.playlists}/$playlistId/tracks?trackId=$trackId',
        options: Options(
          headers: <String, dynamic>{
            Headers.acceptHeader: Headers.jsonContentType,
          },
        ),
      );
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(
        error.response?.data?.toString() ??
            error.message ??
            'Failed to add track to playlist',
      );
    } catch (error) {
      throw ServerException('Failed to execute add track request: $error');
    }
  }

  @override
  Future<void> removeTrackFromPlaylist(int playlistId, int trackId) async {
    try {
      await _dioClient.delete<dynamic>(
        '${ApiConstants.playlists}/$playlistId/tracks/$trackId',
      );
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(
        error.message ?? 'Failed to remove track from playlist',
      );
    } catch (error) {
      throw ServerException('Failed to execute remove track request: $error');
    }
  }

  Future<FormData> _buildPlaylistPayload(
    CreatePlaylistRequest request,
    File? coverImage,
  ) async {
    final dataMap = request.toJson();

    // Convert boolean to string for better backend compatibility in multipart
    if (dataMap.containsKey('isPrivate')) {
      dataMap['isPrivate'] = (dataMap['isPrivate'] == true) ? '1' : '0';
    }

    final formData = FormData.fromMap(dataMap);

    if (coverImage != null) {
      final imageName = path.basename(coverImage.path);
      formData.files.add(
        MapEntry(
          'coverArt', // CHANGED TO coverArt TO MATCH BACKEND
          await MultipartFile.fromFile(coverImage.path, filename: imageName),
        ),
      );
    }

    if (kDebugMode) {
      debugPrint('--- Playlist FormData Content ---');
      for (var element in formData.fields) {
        debugPrint('Field: ${element.key} = ${element.value}');
      }
      for (var element in formData.files) {
        debugPrint('File: ${element.key} = ${element.value.filename}');
      }
      debugPrint('---------------------------------');
    }

    return formData;
  }

  Map<String, dynamic> _extractObjectPayload(Object? data) {
    if (data is! Map<Object?, Object?>) {
      throw const ServerException('Invalid playlist response format');
    }

    final dataMap = Map<String, dynamic>.from(data);
    final nested = dataMap['data'];
    if (nested is Map<Object?, Object?>) {
      return Map<String, dynamic>.from(nested);
    }

    return dataMap;
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

  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException);
  }
}
