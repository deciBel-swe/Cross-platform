import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';

abstract class ITrackCommentsRepository {
  Future<Either<Failure, Comment>> postComment({
    required int trackId,
    required String body,
    required int? timestampSeconds,
  });
}
