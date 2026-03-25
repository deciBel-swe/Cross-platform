import 'dart:async';

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
  final List<Comment> _comments = mockTrackComments
      .map((comment) => comment.toEntity())
      .toList();

  @override
  Future<Either<Failure, Comment>> postComment({
    required int trackId,
    required String body,
    int? timestampSeconds,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final newComment = Comment(
      id: _comments.isEmpty ? 1 : _comments.first.id + 1,
      user: mockCommentUser.toEntity(),
      body: body,
      timestampSeconds: timestampSeconds,
      createdAt: DateTime.now(),
    );

    _comments.insert(0, newComment);
    return Right(newComment);
  }
}
