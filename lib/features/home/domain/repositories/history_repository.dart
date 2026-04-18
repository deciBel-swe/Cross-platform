import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<Track>>> getListeningHistory({
    int page = 0,
    int size = 20,
  });
}