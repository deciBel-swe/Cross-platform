import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/listening_history_page.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

/// Repository implementation backed by the listening-history API.
@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._remoteDatasource);

  final HistoryRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, ListeningHistoryPage>> getListeningHistory({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _remoteDatasource.getListeningHistory(
        page: page,
        size: size,
      );

      return Right(response.toEntity());
    } on NetworkException catch (error) {
      return Left(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> incrementPlayCount({
    required int trackId,
  }) async {
    try {
      await _remoteDatasource.incrementPlayCount(trackId: trackId);
      return const Right(true);
    } on NetworkException catch (error) {
      return Left(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> markTrackCompleted({
    required int trackId,
  }) async {
    try {
      await _remoteDatasource.markTrackCompleted(trackId: trackId);
      return const Right(true);
    } on NetworkException catch (error) {
      return Left(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }
}
