import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

<<<<<<< HEAD
import '../../../../core/errors/failures.dart';
import '../../domain/entities/paginated_engagers.dart';
=======
import '../../../library/data/models/paginated_tracks_model.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
>>>>>>> feat/engage-liked-list
import '../../domain/repositories/track_social_repository.dart';
import '../datasources/track_social_remote_datasource.dart';
import '../models/paginated_engagers_model.dart';

@LazySingleton(as: ITrackSocialRepository, env: [Environment.prod])
class TrackSocialRepositoryImpl implements ITrackSocialRepository {
  const TrackSocialRepositoryImpl(this._datasource);
  final TrackSocialRemoteDatasource _datasource;

  @override
<<<<<<< HEAD
  Future<void> likeTrack(int trackId) => _datasource.likeTrack(trackId);
=======
  Future<PaginatedTracks> getLikedTracks({int page = 0, int size = 20}) async {
    final model = await _datasource.getLikedTracks(page: page, size: size);
    return model.toEntity();
  }

  @override
  Future<void> likeTrack(String trackId) => _datasource.likeTrack(trackId);
>>>>>>> feat/engage-liked-list

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
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
