import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/listening_history_page.dart';

/// Repository contract for the current user's listening history.
abstract class HistoryRepository {
  Future<Either<Failure, ListeningHistoryPage>> getListeningHistory({
    int page = 0,
    int size = 20,
  });

  Future<Either<Failure, bool>> incrementPlayCount({required int trackId});

  Future<Either<Failure, bool>> markTrackCompleted({required int trackId});
}
