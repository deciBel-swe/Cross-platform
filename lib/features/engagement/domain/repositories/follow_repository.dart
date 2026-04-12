import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../features/library_profile/domain/entities/public_profile.dart';
import '../entities/paginated_engagers.dart';

/// Contract for follow-related operations and public-profile fetching.
///
/// Implemented by [FollowRepositoryImpl] in the data layer.
/// Uses [Either] to express success/failure without throwing exceptions
/// into the domain or presentation layers.
abstract class FollowRepository {
  /// Fetches a public profile by [userIdentifier] from `GET /users/{identifier}`.
  ///
  /// Returns [Right(PublicProfile)] on success, including the relationship
  /// flags `isFollowing` and `isFollowedBy`.
  Future<Either<Failure, PublicProfile>> getPublicProfile(
    String userIdentifier,
  );

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

  /// Fetches followers for a user via `GET /users/{userId}/followers`.
  Future<Either<Failure, PaginatedEngagers>> getFollowers({
    required int userId,
    int page = 0,
    int size = 20,
  });

  /// Fetches following for a user via `GET /users/{userId}/following`.
  Future<Either<Failure, PaginatedEngagers>> getFollowing({
    required int userId,
    int page = 0,
    int size = 20,
  });

  /// Fetches suggested users to follow via `GET /users/suggested`.
  Future<Either<Failure, PaginatedEngagers>> getSuggestedUsers({
    int page = 0,
    int size = 20,
  });

  /// Fetches users who follow the current user and are followed back.
  Future<Either<Failure, PaginatedEngagers>> getFriends({
    int page = 0,
    int size = 20,
  });
}
