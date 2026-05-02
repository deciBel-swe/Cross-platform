import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../playlists/data/models/playlist_mapper.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../domain/repositories/playlist_social_repository.dart';
import '../datasources/playlist_social_remote_datasource.dart';

@LazySingleton(as: IPlaylistSocialRepository, env: [Environment.prod, 'dev'])
class PlaylistSocialRepositoryImpl implements IPlaylistSocialRepository {
  PlaylistSocialRepositoryImpl(this._remoteDataSource);
  final PlaylistSocialRemoteDatasource _remoteDataSource;

  @override
  Future<Either<Failure, bool>> toggleLike(
    int playlistId,
    bool isCurrentlyLiked,
  ) async {
    try {
      final isLiked = await _remoteDataSource.toggleLike(
        playlistId,
        isCurrentlyLiked: isCurrentlyLiked,
      );
      return Right(isLiked);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleRepost(
    int playlistId,
    bool isCurrentlyReposted,
  ) async {
    try {
      final isReposted = await _remoteDataSource.toggleRepost(
        playlistId,
        isCurrentlyReposted: isCurrentlyReposted,
      );
      return Right(isReposted);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Playlist>>> getLikedPlaylists(
    String username, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getLikedPlaylists(
        username,
        page: page,
        size: size,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
