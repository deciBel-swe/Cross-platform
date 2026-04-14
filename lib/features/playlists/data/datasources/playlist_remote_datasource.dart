import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/create_playlist_request.dart';
import '../models/playlist_model.dart';

abstract class IPlaylistRemoteDataSource {
  Future<PlaylistModel> getPlaylistDetails(int playlistId);

  Future<List<PlaylistModel>> getUserPlaylists({int page = 0, int size = 20});

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

  Future<PlaylistModel> addTrackToPlaylist(int playlistId, int trackId);

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

      final responseData = response.data as Map<String, dynamic>;

      // check lowercase "secretLink" just in case your backend uses standard JSON camelCase.
      final secretLink =
          responseData['SecretLink'] ?? responseData['secretLink'];

      if (secretLink != null) {
        return secretLink as String;
      } else {
        throw const ServerException(
          'Secret link not found in response payload',
        );
      }
    } on DioException catch (error) {
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
        '${ApiConstants.myPlaylists}/$playlistId',
      );

      final responseData = response.data as Map<String, dynamic>;
      return PlaylistModel.fromJson(
        responseData,
      ); // Parses id, title, and the tracks array
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'Failed to fetch playlist tracks');
    }
  }

  @override
  Future<PlaylistModel> reorderTracks(
    int playlistId,
    List<int> trackIds,
  ) async {
    final response = await _dioClient.patch<dynamic>(
      ApiConstants.updateTracksOrder(playlistId),
      data: {"trackIds": trackIds},
    );

    final responseData = response.data as Map<String, dynamic>;

    // The API returns the updated Playlist object
    return PlaylistModel.fromJson(responseData);
  }

  @override
  Future<PlaylistModel> createPlaylist(
    CreatePlaylistRequest request,
    File? coverImage,
  ) async {
    try {
      final dataMap = request.toJson();
      final formData = FormData.fromMap(dataMap);

      if (coverImage != null) {
        final imageName = coverImage.path.split('/').last;
        formData.files.add(
          MapEntry(
            'CoverArt',
            await MultipartFile.fromFile(coverImage.path, filename: imageName),
          ),
        );
      }

      final response = await _dioClient.post<dynamic>(
        ApiConstants.playlists,
        data: formData,
      );
      final responseData = response.data as Map<String, dynamic>;
      return PlaylistModel.fromJson(responseData);
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'Failed to create playlist');
    } catch (error) {
      throw ServerException('Failed to parse create playlist response: $error');
    }
  }

  @override
  Future<List<PlaylistModel>> getUserPlaylists({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.myPlaylists,
        queryParams: {'page': page, 'size': size},
      );

      final data = response.data;

      if (data == null) {
        return [];
      }

      List<dynamic> contentList = [];

      if (data is Map) {
        contentList = data['content'] as List<dynamic>? ?? [];
      } else if (data is List) {
        contentList = data;
      }

      return contentList.where((item) => item != null).map((json) {
        final cleanMap = Map<String, dynamic>.from(json as Map);
        return PlaylistModel.fromJson(cleanMap);
      }).toList();
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'Failed to fetch playlists');
    } catch (error, stackTrace) {
      debugPrint('==========PARSING CRASH: $error');
      debugPrint('==========STACKTRACE: $stackTrace');
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
      final dataMap = request.toJson();
      final formData = FormData.fromMap(dataMap);

      if (coverImage != null) {
        final imageName = coverImage.path.split('/').last;
        formData.files.add(
          MapEntry(
            'CoverArt',
            await MultipartFile.fromFile(coverImage.path, filename: imageName),
          ),
        );
      }

      final response = await _dioClient.patch<dynamic>(
        '${ApiConstants.playlists}/$playListId',
        data: formData,
      );
      final responseData = response.data as Map<String, dynamic>;
      return PlaylistModel.fromJson(responseData);
    } on DioException catch (error) {
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
      throw ServerException(error.message ?? 'Failed to delete playlist');
    } catch (error) {
      throw ServerException(
        'Failed to execute delete playlist request: $error',
      );
    }
  }

  @override
  Future<PlaylistModel> addTrackToPlaylist(int playlistId, int trackId) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '${ApiConstants.playlists}/$playlistId/tracks',
        data: <String, dynamic>{'trackId': trackId},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: <String, dynamic>{
            Headers.acceptHeader: Headers.jsonContentType,
          },
        ),
      );

      final data = response.data;
      if (data == null) {
        throw ServerException('Empty response from server');
      }

      return PlaylistModel.fromJson(data);
    } on DioException catch (error) {
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
      throw ServerException(
        error.message ?? 'Failed to remove track from playlist',
      );
    } catch (error) {
      throw ServerException('Failed to execute remove track request: $error');
    }
  }
}
