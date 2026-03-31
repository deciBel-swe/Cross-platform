import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/comment_reply.dart';
import '../../domain/repositories/i_track_comments_repository.dart'
    show ITrackCommentsRepository;
import '../datasources/track_comments_remote_data_source.dart';
import '../models/comment_reply_model.dart';
import '../models/post_comment_request_model.dart';
import '../models/post_comment_response_model.dart';

@Environment("prod")
@LazySingleton(as: ITrackCommentsRepository)
class TrackCommentsRepository implements ITrackCommentsRepository {
  TrackCommentsRepository(this._remoteDatasource);

  final ITrackCommentsRemoteDataSource _remoteDatasource;

  @override
  Future<Either<Failure, Comment>> postComment({
    int? commentid,
    required int trackId,
    required String body,
    int? timestampSeconds,
  }) async {
    final req = PostCommentRequestModel(
      body: body,
      timeStampseconds: timestampSeconds,
    );

    try {
      final comment = await _remoteDatasource.postComment(
        trackId: trackId,
        request: req,
      );

      return Right(comment.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments({
    required int trackId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _remoteDatasource.getComments(
        trackId: trackId,
        page: page,
        size: size,
      );

      final comments = response.content
          .map((comment) => comment.toEntity())
          .toList();

      return Right(comments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CommentReply>>> getReplies({
    required int commentId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _remoteDatasource.getReplies(
        commentId: commentId,
        page: page,
        size: size,
      );

      final replies = response.content
          .map((reply) => reply.toEntity())
          .toList();

      return Right(replies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({required int commentId}) async {
    try {
      await _remoteDatasource.deleteComment(commentId: commentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
