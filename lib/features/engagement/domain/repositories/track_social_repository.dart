import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../entities/paginated_engagers.dart';

abstract class ITrackSocialRepository {
  Future<void> likeTrack(int trackId);
  Future<void> unlikeTrack(int trackId);
  Future<void> repostTrack(int trackId);
  Future<void> unrepostTrack(int trackId);

  /// Fetches liked tracks for the current user.
  Future<PaginatedTracks> getLikedTracks({int page = 0, int size = 20});

  /// Fetches a paginated list of users who liked [trackId].
  Future<Either<Failure, PaginatedEngagers>> fetchTrackLikers({
    required int trackId,
    required int page,
    required int size,
  });

  /// Fetches a paginated list of users who reposted [trackId].
  Future<Either<Failure, PaginatedEngagers>> fetchTrackReposters({
    required int trackId,
    required int page,
    required int size,
  });
}
