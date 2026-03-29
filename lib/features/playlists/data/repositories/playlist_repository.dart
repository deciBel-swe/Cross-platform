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
  Future<Either<Failure, Playlist>> createPlaylist(
    PlaylistMetadata metadata,
  ) async {
    try {
      final request = CreatePlaylistRequest(
        title: metadata.title,
        description: metadata.description,
        isPrivate: metadata.isPrivate,
      );

      final model = await _remoteDataSource.createPlaylist(
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
}
