import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/paginated_engagers.dart';
import '../../domain/entities/track_engager.dart';
import '../../domain/repositories/track_social_repository.dart';

@Environment('mock')
@LazySingleton(as: ITrackSocialRepository)
class MockTrackSocialRepository implements ITrackSocialRepository {
  MockTrackSocialRepository();

  static const Duration _mockDelay = Duration(milliseconds: 250);

  /// In-memory like state keyed by trackId.
  /// Persists for the entire app session — cleared only on hot restart.
  final Map<int, bool> _likedTracks = {};

  /// In-memory repost state keyed by trackId.
  final Map<int, bool> _repostedTracks = {};

  static const List<TrackEngager> _mockLikers = [
    TrackEngager(id: 201, username: 'dj_nova', tier: 'PRO', isFollowing: true),
    TrackEngager(
      id: 202,
      username: 'beatsmith_44',
      tier: 'FREE',
      isFollowing: false,
    ),
    TrackEngager(
      id: 203,
      username: 'luna_waves',
      tier: 'PRO',
      isFollowing: true,
    ),
    TrackEngager(
      id: 204,
      username: 'vinyl_dreams',
      tier: 'FREE',
      isFollowing: false,
    ),
    TrackEngager(
      id: 205,
      username: 'echo_chamber',
      tier: 'FREE',
      isFollowing: false,
    ),
  ];

  static const List<TrackEngager> _mockReposters = [
    TrackEngager(
      id: 301,
      username: 'bass_captain',
      tier: 'PRO',
      isFollowing: false,
    ),
    TrackEngager(
      id: 302,
      username: 'melodic_mind',
      tier: 'FREE',
      isFollowing: true,
    ),
    TrackEngager(
      id: 303,
      username: 'synth_rider',
      tier: 'PRO',
      isFollowing: false,
    ),
  ];

  @override
  Future<void> likeTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
    _likedTracks[trackId] = true;
  }

  @override
  Future<void> unlikeTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
    _likedTracks[trackId] = false;
  }

  @override
  Future<void> repostTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
    _repostedTracks[trackId] = true;
  }

  @override
  Future<void> unrepostTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
    _repostedTracks[trackId] = false;
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> fetchTrackLikers({
    required int trackId,
    required int page,
    required int size,
  }) async {
    await Future<void>.delayed(_mockDelay);
    return Right(
      PaginatedEngagers(
        content: _mockLikers,
        pageNumber: page,
        pageSize: size,
        totalElements: _mockLikers.length,
        totalPages: 1,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> fetchTrackReposters({
    required int trackId,
    required int page,
    required int size,
  }) async {
    await Future<void>.delayed(_mockDelay);
    return Right(
      PaginatedEngagers(
        content: _mockReposters,
        pageNumber: page,
        pageSize: size,
        totalElements: _mockReposters.length,
        totalPages: 1,
        isLast: true,
      ),
    );
  }
}
