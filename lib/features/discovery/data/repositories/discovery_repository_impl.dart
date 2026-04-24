import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/discovery_search_response.dart';
import '../../domain/entities/discovery_search_type.dart';
import '../../domain/entities/paginated_discovery_tracks.dart';
import '../../domain/repositories/discovery_repository.dart';
import '../datasources/discovery_remote_datasource.dart';
import '../models/discovery_search_response_model.dart';
import '../models/paginated_discovery_tracks_model.dart';

@LazySingleton(as: DiscoveryRepository, env: [Environment.prod])
class DiscoveryRepositoryImpl implements DiscoveryRepository {
  const DiscoveryRepositoryImpl(this._remoteDataSource);

  final DiscoveryRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, DiscoverySearchResponse>> search({
    required String query,
    required DiscoverySearchType type,
    required int page,
    required int size,
  }) async {
    try {
      final response = await _remoteDataSource.search(
        query: query,
        type: type,
        page: page,
        size: size,
      );
      return Right(response.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure('An unexpected error occurred: $error'));
    }
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getTrendingTracks({
    String? genre,
    required int limit,
  }) async {
    try {
      final response = await _remoteDataSource.getTrendingTracks(
        genre: genre,
        limit: limit,
      );
      return Right(response.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure('An unexpected error occurred: $error'));
    }
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getGenreStation({
    required String genre,
    required int page,
    required int size,
  }) async {
    try {
      final response = await _remoteDataSource.getGenreStation(
        genre: genre,
        page: page,
        size: size,
      );
      return Right(response.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure('An unexpected error occurred: $error'));
    }
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getLikesStation() async {
    try {
      final response = await _remoteDataSource.getLikesStation();
      return Right(response.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure('An unexpected error occurred: $error'));
    }
  }
}
