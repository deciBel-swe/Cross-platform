import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/paginated_engagers.dart';

abstract class ITrackSocialRepository {
  Future<void> likeTrack(int trackId);
  Future<void> unlikeTrack(int trackId);
  Future<void> repostTrack(int trackId);
  Future<void> unrepostTrack(int trackId);

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
