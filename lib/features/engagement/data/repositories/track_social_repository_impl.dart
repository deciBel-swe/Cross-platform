import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../library/data/models/paginated_tracks_model.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../../domain/entities/paginated_engagers.dart';
import '../../domain/repositories/track_social_repository.dart';
import '../datasources/track_social_remote_datasource.dart';
import '../models/paginated_engagers_model.dart';

@LazySingleton(as: ITrackSocialRepository, env: [Environment.prod])
class TrackSocialRepositoryImpl implements ITrackSocialRepository {
  const TrackSocialRepositoryImpl(this._datasource);
  final TrackSocialRemoteDatasource _datasource;

  @override
  Future<PaginatedTracks> getLikedTracks({
    int page = 0,
    int size = 20,
    int? userId,
    String? username,
  }) async {
    final model = username != null && username.trim().isNotEmpty
        ? await _datasource.getLikedTracks(
            page: page,
            size: size,
            username: username,
          )
        : userId != null
        ? await _datasource.getLikedTracks(
            page: page,
            size: size,
            userId: userId,
          )
        : await _datasource.getLikedTracks(page: page, size: size);
    return model.toEntity();
  }

  @override
  Future<PaginatedTracks> getRepostedTracks({
    int page = 0,
    int size = 20,
    int? userId,
    String? username,
  }) async {
    final model = username != null && username.trim().isNotEmpty
        ? await _datasource.getRepostedTracks(
            page: page,
            size: size,
            username: username,
          )
        : userId != null
        ? await _datasource.getRepostedTracks(
            page: page,
            size: size,
            userId: userId,
          )
        : await _datasource.getRepostedTracks(page: page, size: size);
    return model.toEntity();
  }

  @override
  Future<void> likeTrack(int trackId) => _datasource.likeTrack(trackId);

  @override
  Future<void> unlikeTrack(int trackId) => _datasource.unlikeTrack(trackId);

  @override
  Future<void> repostTrack(int trackId) => _datasource.repostTrack(trackId);

  @override
  Future<void> unrepostTrack(int trackId) => _datasource.unrepostTrack(trackId);

  @override
  Future<Either<Failure, PaginatedEngagers>> fetchTrackLikers({
    required int trackId,
    required int page,
    required int size,
  }) async {
    try {
      final model = await _datasource.fetchTrackLikers(
        trackId: trackId,
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> fetchTrackReposters({
    required int trackId,
    required int page,
    required int size,
  }) async {
    try {
      final model = await _datasource.fetchTrackReposters(
        trackId: trackId,
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> reportTrack({
    required int trackId,
    required String reason,
    String? description,
  }) =>
      _datasource.reportTrack(
        trackId: trackId,
        reason: reason,
        description: description,
      );
}
