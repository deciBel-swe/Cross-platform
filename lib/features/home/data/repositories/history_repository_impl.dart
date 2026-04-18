import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._remoteDatasource);

  final HistoryRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<Track>>> getListeningHistory({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _remoteDatasource.getListeningHistory(
        page: page,
        size: size,
      );

      return Right(response.content);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}