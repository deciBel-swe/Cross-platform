import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/comment_reply.dart';
import '../entities/comment.dart';

abstract class ITrackCommentsRepository {
  Future<Either<Failure, Comment>> postComment({
    required int trackId,
    required String body,
    required int? timestampSeconds,
    int? commentid,
  });

  Future<Either<Failure, List<Comment>>> getComments({
    required int trackId,
    int page = 0,
    int size = 20,
  });

  Future<Either<Failure, List<CommentReply>>> getReplies({
    required int commentId,
    int page = 0,
    int size = 20,
  });

  Future<Either<Failure, void>> deleteComment({required int commentId});
}
