import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/comment_reply.dart';
import '../../domain/repositories/i_track_comments_repository.dart';
import '../datasources/track_comments_mock_fixtures.dart';
import '../models/comment_reply_model.dart';
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

    final serverId = _liveComments.length + 101;

    final newComment = Comment(
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
  Future<Either<Failure, List<Comment>>> getComments({
    required int trackId,
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(TrackCommentsMockFixtures.mockDelay);

    try {
      return Right(List<Comment>.from(_liveComments));
    } catch (e) {
      return const Left(ServerFailure('Mock: Failed to load comments'));
    }
  }

  @override
  Future<Either<Failure, List<CommentReply>>> getReplies({
    required int commentId,
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(TrackCommentsMockFixtures.mockDelay);

    try {
      final response = PaginatedRepliesResponseModel.fromJson(
        TrackCommentsMockFixtures.mockRepliesResponse,
      );

      final replies = response.content
          .map((reply) => reply.toEntity())
          .toList();

      return Right(replies);
    } catch (e) {
      return const Left(ServerFailure('Mock: Failed to load replies'));
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
