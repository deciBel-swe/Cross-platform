import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/paginated_feed.dart';
import '../../domain/repositories/i_feed_repository.dart';
import '../datasources/feed_data_datasource.dart';
import '../models/paginated_feed_model.dart';

/// Production feed repository — thin Either wrapper around the datasource.
@Environment(Environment.prod)
@LazySingleton(as: IFeedRepository)
class FeedRepositoryImpl implements IFeedRepository {
  const FeedRepositoryImpl(this._remote);

  final IFeedRemoteDatasource _remote;

  @override
  Future<Either<Failure, PaginatedFeed>> getFeed({
    required int page,
    required int size,
  }) async {
    try {
      // Datasource returns the model, convert to entity here.
      final model = await _remote.getFeed(page: page, size: size);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedFeed>> getDiscoverFeed({
    required int page,
    required int size,
  }) async {
    try {
      final model = await _remote.getDiscoverFeed(
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
