import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/create_playlist_request.dart';
import '../models/playlist_model.dart';

abstract class IPlaylistRemoteDataSource {
  Future<PlaylistModel> createPlaylist(CreatePlaylistRequest request);
  Future<PlaylistModel> updatePlaylist(
    int playListId,
    CreatePlaylistRequest request,
  );
  Future<void> deletePlayList(int playListId);
}

@Injectable(as: IPlaylistRemoteDataSource)
class PlaylistRemoteDatasource implements IPlaylistRemoteDataSource {
  const PlaylistRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<PlaylistModel> createPlaylist(CreatePlaylistRequest request) async {
    try {
      // TODO: the playlist title cannot exceed 100 char
      final response = await _dioClient.post<dynamic>(
        '/api/playlists',
        data: request.toJson(),
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
  Future<PlaylistModel> updatePlaylist(
    int playListId,
    CreatePlaylistRequest request,
  ) async {
    try {
      final response = await _dioClient.patch<dynamic>(
        '/api/playlists/$playListId',
        data: request.toJson(),
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
        '/api/playlist/$playListId',
      ); // 204 no content
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'Failed to delete playlist');
    } catch (error) {
      throw ServerException(
        'Failed to execute delete playlist request: $error',
      );
    }
  }
}
