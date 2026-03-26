import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/public_profile.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/repositories/follow_repository.dart';

/// In-memory mock implementation of [FollowRepository].
///
/// Returns hardcoded fake data so the feature can be tested without a
/// backend connection. Simulates a 500 ms network delay on every call
/// to verify loading states and optimistic-update behaviour.
class MockFollowRepository implements FollowRepository {
  /// Tracks follow state per userId so toggling persists across calls.
  final Map<int, bool> _followState = {};

  /// Returns a fake public profile for any [userId].
  ///
  /// The mock user "demo_artist" has 128 followers and 42 following.
  /// `isFollowing` comes from the in-memory map (defaults to `false`).
  /// `isFollowedBy` is `true` for even userIds (to test Follow Back).
  @override
  Future<Either<Failure, PublicProfile>> getPublicProfile(int userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final isFollowing = _followState[userId] ?? false;
    final isFollowedBy = userId.isEven; // even IDs "follow you back"

    return Right(
      PublicProfile(
        id: userId,
        username: 'demo_artist_$userId',
        tier: userId % 3 == 0 ? 'PRO' : 'FREE',
        profile: const PublicProfileDetails(
          bio: 'This is a mock profile for testing the follow feature. '
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
}
