import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/data/datasources/track_comments_remote_data_source.dart';
import 'package:decibel/features/library/data/models/comment_reply_model.dart';
import 'package:decibel/features/library/data/models/comment_user_model.dart';
import 'package:decibel/features/library/data/models/paginated_comments_response_model.dart';
import 'package:decibel/features/library/data/models/paginated_replies_response_model.dart';
import 'package:decibel/features/library/data/models/post_comment_request_model.dart';
import 'package:decibel/features/library/data/models/post_comment_response_model.dart';
import 'package:decibel/features/library/data/repositories/track_comments_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackCommentsRemoteDataSource extends Mock
    implements ITrackCommentsRemoteDataSource {}

void main() {
  late MockTrackCommentsRemoteDataSource remote;
  late TrackCommentsRepository repository;

  setUpAll(() {
    registerFallbackValue(
      const PostCommentRequestModel(body: 'fallback', timeStampseconds: 1),
    );
  });

  setUp(() {
    remote = MockTrackCommentsRemoteDataSource();
    repository = TrackCommentsRepository(remote);
  });

  group('postComment', () {
    test('returns comment entity and sends request body', () async {
      when(
        () => remote.postComment(trackId: 7, request: any(named: 'request')),
      ).thenAnswer((_) async => _commentModel(id: 99, body: 'nice'));

      final result = await repository.postComment(
        trackId: 7,
        body: 'nice',
        timestampSeconds: 42,
      );

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected success'), (comment) {
        expect(comment.commentid, 99);
        expect(comment.body, 'nice');
        expect(comment.timestampSeconds, 42);
      });

      final captured =
          verify(
                () => remote.postComment(
                  trackId: 7,
                  request: captureAny(named: 'request'),
                ),
              ).captured.single
              as PostCommentRequestModel;
      expect(captured.body, 'nice');
      expect(captured.timeStampseconds, 42);
    });

    test('returns ServerFailure when remote throws', () async {
      when(
        () => remote.postComment(trackId: 7, request: any(named: 'request')),
      ).thenThrow(Exception('boom'));

      final result = await repository.postComment(trackId: 7, body: 'nice');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('expected failure'),
      );
    });
  });

  group('getComments', () {
    test('returns paginated comments entity', () async {
      when(() => remote.getComments(trackId: 7, page: 1, size: 2)).thenAnswer(
        (_) async => PaginatedCommentsResponseModel(
          content: [_commentModel(id: 1), _commentModel(id: 2)],
          pageNumber: 1,
          pageSize: 2,
          totalElements: 4,
          totalPages: 2,
          isLast: true,
        ),
      );

      final result = await repository.getComments(trackId: 7, page: 1, size: 2);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected success'), (page) {
        expect(page.content.map((comment) => comment.commentid), [1, 2]);
        expect(page.pageNumber, 1);
        expect(page.isLast, isTrue);
      });
    });

    test('returns ServerFailure when remote throws', () async {
      when(
        () => remote.getComments(trackId: 7, page: 0, size: 20),
      ).thenThrow(Exception('boom'));

      final result = await repository.getComments(trackId: 7);

      expect(result.isLeft(), isTrue);
    });
  });

  group('getReplies', () {
    test('returns paginated replies entity', () async {
      when(() => remote.getReplies(commentId: 4, page: 0, size: 5)).thenAnswer(
        (_) async => PaginatedRepliesResponseModel(
          content: [_replyModel(id: 10), _replyModel(id: 11)],
          pageNumber: 0,
          pageSize: 5,
          totalElements: 2,
          totalPages: 1,
          isLast: true,
        ),
      );

      final result = await repository.getReplies(
        commentId: 4,
        page: 0,
        size: 5,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('expected success'),
        (page) =>
            expect(page.content.map((reply) => reply.commentId), [10, 11]),
      );
    });

    test('returns ServerFailure when remote throws', () async {
      when(
        () => remote.getReplies(commentId: 4, page: 0, size: 20),
      ).thenThrow(Exception('boom'));

      final result = await repository.getReplies(commentId: 4);

      expect(result.isLeft(), isTrue);
    });
  });

  group('postReply', () {
    test('returns reply entity', () async {
      when(
        () => remote.postReply(commentId: 4, body: 'reply'),
      ).thenAnswer((_) async => _replyModel(id: 12, body: 'reply'));

      final result = await repository.postReply(commentId: 4, body: 'reply');

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected success'), (reply) {
        expect(reply.commentId, 12);
        expect(reply.body, 'reply');
      });
    });

    test('returns ServerFailure when remote throws', () async {
      when(
        () => remote.postReply(commentId: 4, body: 'reply'),
      ).thenThrow(Exception('boom'));

      final result = await repository.postReply(commentId: 4, body: 'reply');

      expect(result.isLeft(), isTrue);
    });
  });

  group('deleteComment', () {
    test('returns right null on success', () async {
      when(() => remote.deleteComment(commentId: 4)).thenAnswer((_) async {});

      final result = await repository.deleteComment(commentId: 4);

      expect(result.isRight(), isTrue);
      verify(() => remote.deleteComment(commentId: 4)).called(1);
    });

    test('returns ServerFailure when remote throws', () async {
      when(
        () => remote.deleteComment(commentId: 4),
      ).thenThrow(Exception('boom'));

      final result = await repository.deleteComment(commentId: 4);

      expect(result.isLeft(), isTrue);
    });
  });
}

const _user = CommentUserModel(id: 1, username: 'tarek', avatarUrl: null);

PostCommentResponseModel _commentModel({
  required int id,
  String body = 'body',
}) {
  return PostCommentResponseModel(
    commentid: id,
    user: _user,
    body: body,
    timestampSeconds: 42,
    createdAt: DateTime(2026, 1, 1),
    replycount: 2,
  );
}

CommentReplyModel _replyModel({required int id, String body = 'reply'}) {
  return CommentReplyModel(
    commentId: id,
    user: _user,
    body: body,
    createdAt: DateTime(2026, 1, 1),
  );
}
