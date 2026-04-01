import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../features/library_profile/domain/entities/public_profile.dart';

/// Contract for follow-related operations and public-profile fetching.
///
/// Implemented by [FollowRepositoryImpl] in the data layer.
/// Uses [Either] to express success/failure without throwing exceptions
/// into the domain or presentation layers.
abstract class FollowRepository {
  /// Fetches a public profile by [userId] from `GET /users/{userId}`.
  ///
  /// Returns [Right(PublicProfile)] on success, including the relationship
  /// flags `isFollowing` and `isFollowedBy`.
  Future<Either<Failure, PublicProfile>> getPublicProfile(int userId);

  /// Follows the user with [userId] via `POST /users/{userId}/follow`.
  ///
  /// Returns [Right(true)] if the server confirms the follow,
  /// or [Left(Failure)] on error.
  Future<Either<Failure, bool>> followUser(int userId);

  /// Unfollows the user with [userId] via `DELETE /users/{userId}/follow`.
  ///
  /// Returns [Right(false)] if the server confirms the unfollow,
  /// or [Left(Failure)] on error.
  Future<Either<Failure, bool>> unfollowUser(int userId);
}
