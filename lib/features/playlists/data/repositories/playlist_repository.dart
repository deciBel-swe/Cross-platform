import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/playlist_metadata.dart';
import '../../domain/repositories/i_playlist_repository.dart';
import '../datasources/playlist_remote_datasource.dart';
import '../models/create_playlist_request.dart';
import '../models/playlist_mapper.dart';

@Injectable(as: IPlaylistRepository)
class PlaylistRepository implements IPlaylistRepository {
  const PlaylistRepository(this._remoteDataSource);

  final IPlaylistRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Playlist>> reorderTracks(
    int playlistId,
    List<int> trackIds,
  ) async {
    try {
      final result = await _remoteDataSource.reorderTracks(
        playlistId,
        trackIds,
      );
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(
        ServerFailure('An unexpected error occurred: ${error.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Playlist>> getPlaylistDetails(int playlistId) async {
    try {
      final model = await _remoteDataSource.getPlaylistDetails(playlistId);

      // Map the Data Model (with tracks) to the Domain Entity
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Playlist>>> getUserPlaylists({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final playlistModels = await _remoteDataSource.getUserPlaylists(
        page: page,
        size: size,
      );

      final playlists = playlistModels
          .map((model) => model.toEntity())
          .toList();

      return Right(playlists);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure('An unexpected error occurred: $error'));
    }
  }

  @override
  Future<Either<Failure, Playlist>> createPlaylist(
    PlaylistMetadata metadata,
  ) async {
    try {
      final request = CreatePlaylistRequest(
        title: metadata.title,
        description: metadata.description,
        isPrivate: metadata.isPrivate,
      );

      final model = await _remoteDataSource.createPlaylist(request);

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Playlist>> updatePlaylist(
    int playlistId,
    PlaylistMetadata metadata,
  ) async {
    try {
      final request = CreatePlaylistRequest(
        title: metadata.title,
        description: metadata.description,
        isPrivate: metadata.isPrivate,
      );

      final model = await _remoteDataSource.updatePlaylist(
        playlistId,
        request,
        metadata.coverImage,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlaylist(int playlistId) async {
    try {
      await _remoteDataSource.deletePlayList(playlistId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getPlaylistSecretLink(int playlistId) async {
    try {
      final secretLink = await _remoteDataSource.getPlaylistSecretLink(playlistId);
      
      return Right(secretLink);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(
        ServerFailure('An unexpected error occurred: ${error.toString()}'),
      );
    }
  }
}
