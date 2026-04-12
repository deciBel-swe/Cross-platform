import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../features/library_profile/domain/entities/public_profile.dart';
import '../../../../features/library_profile/domain/entities/public_profile_social_links.dart';
import '../../domain/entities/paginated_engagers.dart';
import '../../domain/entities/track_engager.dart';
import '../../domain/repositories/follow_repository.dart';

/// In-memory mock implementation of [FollowRepository].
///
/// Returns hardcoded fake data so the feature can be tested without a
/// backend connection. Simulates a 500 ms network delay on every call
/// to verify loading states and optimistic-update behaviour.
class MockFollowRepository implements FollowRepository {
  /// Tracks follow state per userId so toggling persists across calls.
  final Map<int, bool> _followState = {};

  /// Returns a fake public profile for any [userIdentifier].
  ///
  /// The mock user "demo_artist" has 128 followers and 42 following.
  /// `isFollowing` comes from the in-memory map (defaults to `false`).
  /// `isFollowedBy` is `true` for even userIds (to test Follow Back).
  @override
  Future<Either<Failure, PublicProfile>> getPublicProfile(
    String userIdentifier,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final parsedUserId = int.tryParse(userIdentifier);
    final userId =
        parsedUserId ?? userIdentifier.toLowerCase().hashCode.abs() % 100000;

    final isFollowing = _followState[userId] ?? false;
    final isFollowedBy = userId.isEven; // even IDs "follow you back"

    return Right(
      PublicProfile(
        id: userId,
        username: 'demo_artist_$userId',
        tier: userId % 3 == 0 ? 'PRO' : 'FREE',
        profile: const PublicProfileDetails(
          bio:
              'This is a mock profile for testing the follow feature. '
              'It shows how the public profile screen looks with real data.',
          location: 'Cairo, Egypt',
          avatarUrl: null,
          coverPhotoUrl: null,
          favoriteGenres: <String>['Lo-fi', 'House', 'Electronic'],
        ),
        socialLinks: const PublicProfileSocialLinks(
          instagram: 'https://instagram.com/demo_artist',
          twitter: 'https://x.com/demo_artist',
          website: 'https://decibel.app/demo_artist',
          supportLink: null,
        ),
        stats: PublicStats(
          followersCount: 128 + (isFollowing ? 1 : 0),
          followingCount: 42,
          trackCount: 7,
        ),
        isFollowing: isFollowing,
        isFollowedBy: isFollowedBy,
        isBlocked: false,
      ),
    );
  }

  /// Simulates a follow action. Stores `true` in the in-memory map.
  ///
  /// Returns `Right(true)` after a 300 ms simulated delay.
  @override
  Future<Either<Failure, bool>> followUser(int userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _followState[userId] = true;
    return const Right(true);
  }

  /// Simulates an unfollow action. Stores `false` in the in-memory map.
  ///
  /// Returns `Right(false)` after a 300 ms simulated delay.
  @override
  Future<Either<Failure, bool>> unfollowUser(int userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _followState[userId] = false;
    return const Right(false);
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getFollowers({
    required int userId,
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final users = List<TrackEngager>.generate(size, (index) {
      final id = (page * size) + index + 1;
      return TrackEngager(
        id: id,
        username: 'follower_$id',
        avatarUrl: null,
        tier: id % 3 == 0 ? 'PRO' : 'FREE',
        isFollowing: _followState[id] ?? id.isEven,
      );
    });

    return Right(
      PaginatedEngagers(
        content: users,
        pageNumber: page,
        pageSize: size,
        totalElements: 200,
        totalPages: 10,
        isLast: page >= 9,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getFollowing({
    required int userId,
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final users = List<TrackEngager>.generate(size, (index) {
      final id = 1000 + (page * size) + index + 1;
      return TrackEngager(
        id: id,
        username: 'following_$id',
        avatarUrl: null,
        tier: id % 4 == 0 ? 'PRO' : 'FREE',
        isFollowing: _followState[id] ?? true,
      );
    });

    return Right(
      PaginatedEngagers(
        content: users,
        pageNumber: page,
        pageSize: size,
        totalElements: 120,
        totalPages: 6,
        isLast: page >= 5,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getSuggestedUsers({
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final users = List<TrackEngager>.generate(size, (index) {
      final id = 5000 + (page * size) + index + 1;
      return TrackEngager(
        id: id,
        username: 'suggested_$id',
        avatarUrl: null,
        tier: id % 5 == 0 ? 'PRO' : 'FREE',
        isFollowing: _followState[id] ?? false,
      );
    });

    return Right(
      PaginatedEngagers(
        content: users,
        pageNumber: page,
        pageSize: size,
        totalElements: 80,
        totalPages: 4,
        isLast: page >= 3,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getFriends({
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Simulate mutual friends (users who both follow you and you follow back)
    final users = List<TrackEngager>.generate(3, (index) {
      final id = 9000 + index + 1;
      return TrackEngager(
        id: id,
        username: 'mutual_friend_$id',
        avatarUrl: null,
        tier: 'PRO',
        isFollowing: true,
      );
    });

    return Right(
      PaginatedEngagers(
        content: users,
        pageNumber: 0,
        pageSize: size,
        totalElements: 3,
        totalPages: 1,
        isLast: true,
      ),
    );
  }
}
