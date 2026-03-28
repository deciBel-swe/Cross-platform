import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/i_track_comments_repository.dart';
import '../datasources/track_comments_mock_fixtures.dart';
import '../models/comment_user_model.dart';
import '../models/post_comment_response_model.dart';

@Environment("mock")
@LazySingleton(as: ITrackCommentsRepository)
class TrackCommentsMockRepository implements ITrackCommentsRepository {
  // Local state to simulate a database
  final List<Comment> _liveComments = mockTrackComments
      .map((comment) => comment.toEntity())
      .toList();

  @override
  Future<Either<Failure, Comment>> postComment({
    int? commentid, // Temporary ID from Notifier
    required int trackId,
    required String body,
    int? timestampSeconds,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final serverId = _liveComments.length + 101;

    final newComment = Comment(
      commentid: serverId,
      user: mockCommentUser.toEntity(),
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
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    try {
      // Return the live list, not the static fixture
      return Right(List.from(_liveComments));
    } catch (e) {
      return const Left(ServerFailure('Mock: Failed to load comments'));
    }
  }
}
