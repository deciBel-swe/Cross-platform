import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/comment_reply.dart';
import '../../domain/entities/paginated_comment_reply.dart';
import '../../domain/entities/paginated_comments.dart';
import '../../domain/repositories/i_track_comments_repository.dart';
import '../datasources/track_comments_mock_fixtures.dart';
import '../models/comment_user_model.dart';
import '../models/paginated_replies_response_model.dart';
import '../models/post_comment_response_model.dart';

@Environment('mock')
@LazySingleton(as: ITrackCommentsRepository)
class TrackCommentsMockRepository implements ITrackCommentsRepository {
  final List<Comment> _liveComments = TrackCommentsMockFixtures
      .mockTrackComments
      .map((comment) => comment.toEntity())
      .toList();

  @override
  Future<Either<Failure, Comment>> postComment({
    int? commentid,
    required int trackId,
    required String body,
    int? timestampSeconds,
  }) async {
    await Future<void>.delayed(TrackCommentsMockFixtures.mockDelay);

    final serverId = DateTime.now().millisecondsSinceEpoch;
    final newComment = Comment(
      replycount: 0,
      commentid: serverId,
      user: TrackCommentsMockFixtures.mockCommentUser.toEntity(),
      body: body,
      timestampSeconds: timestampSeconds,
      createdAt: DateTime.now(),
    );

    _liveComments.insert(0, newComment);

    return Right(newComment);
  }

  @override
  Future<Either<Failure, PaginatedComments>> getComments({
    required int trackId,
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(TrackCommentsMockFixtures.mockDelay);

    try {
      final paginatedComments = PaginatedComments(
        content: List<Comment>.from(_liveComments),
        pageNumber: page,
        pageSize: size,
        totalElements: _liveComments.length,
        totalPages: 1,
        isLast: true,
      );
      return Right(paginatedComments);
    } catch (e) {
      return const Left(ServerFailure('Mock: Failed to load comments'));
    }
  }

  @override
  Future<Either<Failure, PaginatedReplies>> getReplies({
    required int commentId,
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(TrackCommentsMockFixtures.mockDelay);

    try {
      final response = PaginatedRepliesResponseModel.fromJson(
        TrackCommentsMockFixtures.mockRepliesResponse,
      );

      return Right(response.toEntity());
    } catch (e) {
      return const Left(ServerFailure('Mock: Failed to load replies'));
    }
  }

  @override
  Future<Either<Failure, CommentReply>> postReply({
    required int commentId,
    required String body,
  }) async {
    await Future<void>.delayed(TrackCommentsMockFixtures.mockDelay);

    try {
      final serverId = DateTime.now().millisecondsSinceEpoch;

      final newReply = CommentReply(
        commentId: serverId,
        user: TrackCommentsMockFixtures.mockCommentUser.toEntity(),
        body: body,
        createdAt: DateTime.now(),
      );

      final index = _liveComments.indexWhere((c) => c.commentid == commentId);
      if (index != -1) {
        final comment = _liveComments[index];
        _liveComments[index] = Comment(
          commentid: comment.commentid,
          user: comment.user,
          body: comment.body,
          timestampSeconds: comment.timestampSeconds,
          createdAt: comment.createdAt,
          replycount: comment.replycount + 1,
        );
      }

      return Right(newReply);
    } catch (e) {
      return const Left(ServerFailure('Mock: Failed to post reply'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({required int commentId}) async {
    await Future<void>.delayed(TrackCommentsMockFixtures.mockDelay);

    try {
      _liveComments.removeWhere((comment) => comment.commentid == commentId);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Mock: Failed to delete comment'));
    }
  }
}
