import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../library_profile/data/models/public_profile_model.dart';
import '../../../library_profile/domain/entities/public_profile.dart';
import '../../domain/entities/paginated_engagers.dart';
import '../../domain/repositories/follow_repository.dart';
import '../datasources/follow_remote_data_source.dart';
import '../models/paginated_engagers_model.dart';

/// Concrete implementation of [FollowRepository].
///
/// Delegates to [IFollowRemoteDataSource] for network calls and maps
/// data-layer exceptions into domain-layer [Failure] objects using
/// [Either] from Dartz.
@LazySingleton(as: FollowRepository)
class FollowRepositoryImpl implements FollowRepository {
  const FollowRepositoryImpl(this._remoteDataSource);

  final IFollowRemoteDataSource _remoteDataSource;

  /// Fetches a public profile and converts it to a domain entity.
  ///
  /// Returns [Right(PublicProfile)] on success,
  /// or [Left(Failure)] if a network or parsing error occurs.
  @override
  Future<Either<Failure, PublicProfile>> getPublicProfile(
    String userIdentifier,
  ) async {
    try {
      final model = await _remoteDataSource.getPublicProfile(userIdentifier);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Sends a follow request and returns the confirmed follow state.
  ///
  /// Returns [Right(isFollowing)] on success (expected `true`),
  /// or [Left(Failure)] on error.
  @override
  Future<Either<Failure, bool>> followUser(int userId) async {
    try {
      final response = await _remoteDataSource.followUser(userId);
      return Right(response.isFollowing);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Sends an unfollow request and returns the confirmed follow state.
  ///
  /// Returns [Right(isFollowing)] on success (expected `false`),
  /// or [Left(Failure)] on error.
  @override
  Future<Either<Failure, bool>> unfollowUser(int userId) async {
    try {
      final response = await _remoteDataSource.unfollowUser(userId);
      return Right(response.isFollowing);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getFollowers({
    required int userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final model = await _remoteDataSource.getFollowers(
        userId: userId,
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getFollowing({
    required int userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final model = await _remoteDataSource.getFollowing(
        userId: userId,
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getSuggestedUsers({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final model = await _remoteDataSource.getSuggestedUsers(
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getFriends({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final model = await _remoteDataSource.getFriends(page: page, size: size);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
