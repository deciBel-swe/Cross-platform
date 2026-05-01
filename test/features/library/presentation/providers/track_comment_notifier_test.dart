import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/comment.dart';
import 'package:decibel/features/library/domain/entities/comment_reply.dart';
import 'package:decibel/features/library/domain/entities/comment_user.dart';
import 'package:decibel/features/library/domain/entities/paginated_comment_reply.dart';
import 'package:decibel/features/library/domain/entities/paginated_comments.dart';
import 'package:decibel/features/library/domain/repositories/i_track_comments_repository.dart';
import 'package:decibel/features/library/presentation/notifiers/track_comment_notifier.dart';
import 'package:decibel/features/library/presentation/providers/comments_repository_provider.dart';
import 'package:decibel/features/library/presentation/state/track_comment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackCommentsRepository extends Mock
    implements ITrackCommentsRepository {}

void main() {
  late MockTrackCommentsRepository repository;

  setUp(() {
    repository = MockTrackCommentsRepository();

    when(
      () => repository.getComments(
        trackId: any(named: 'trackId'),
        page: any(named: 'page'),
        size: any(named: 'size'),
      ),
    ).thenAnswer((_) async => Right(_paginatedComments([])));

    when(
      () => repository.getReplies(
        commentId: any(named: 'commentId'),
        page: any(named: 'page'),
        size: any(named: 'size'),
      ),
    ).thenAnswer((_) async => Right(_paginatedReplies([])));
  });

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [commentRepositoryProvider.overrideWithValue(repository)],
    );

    addTearDown(container.dispose);
    return container;
  }

  group('TrackCommentNotifier initial state', () {
    test('build returns default comments state', () async {
      final container = buildContainer();

      final state = container.read(trackCommentsProvider(1));

      expect(state.comments, isEmpty);
      expect(state.selectedTimestampSeconds, isNull);
      expect(state.isSubmitting, isFalse);
      expect(state.isLoadingComments, isFalse);
      expect(state.loadingReplyIds, isEmpty);
      expect(state.repliesByCommentId, isEmpty);
      expect(state.expandedCommentIds, isEmpty);
      expect(state.sortOption, CommentSortOption.newest);
      expect(state.currentCommentsPage, 0);
      expect(state.isLastCommentsPage, isFalse);
      expect(state.activeReplyCommentId, isNull);
      expect(state.replyPrefillText, isNull);
    });
  });

  group('timestamp functions', () {
    test('selectTimestamp updates selectedTimestampSeconds', () {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.selectTimestamp(25);

      expect(
        container.read(trackCommentsProvider(1)).selectedTimestampSeconds,
        25,
      );
    });
  });

  group('reply mode functions', () {
    test(
      'setReplyingTo sets activeReplyCommentId and starts loading replies',
      () async {
        final container = buildContainer();
        final notifier = container.read(trackCommentsProvider(1).notifier);
        final comment = _comment(id: 10, timestampSeconds: 5);

        notifier.setReplyingTo(comment);

        var state = container.read(trackCommentsProvider(1));
        expect(state.activeReplyCommentId, 10);
        expect(state.expandedCommentIds.contains(10), isTrue);
        expect(state.loadingReplyIds.contains(10), isTrue);

        await Future<void>.delayed(Duration.zero);

        state = container.read(trackCommentsProvider(1));
        expect(state.loadingReplyIds.contains(10), isFalse);
        expect(state.repliesByCommentId[10], isNotNull);
      },
    );

    test('clearReplyMode clears activeReplyCommentId and replyPrefillText', () {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.setReplyingTo(_comment(id: 10, timestampSeconds: 5));
      notifier.clearReplyMode();

      final state = container.read(trackCommentsProvider(1));
      expect(state.activeReplyCommentId, isNull);
      expect(state.replyPrefillText, isNull);
    });

    test('handleInputChanged does nothing when input is not empty', () {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.setReplyingTo(_comment(id: 10, timestampSeconds: 5));

      expect(container.read(trackCommentsProvider(1)).activeReplyCommentId, 10);
    });

    test('handleInputChanged clears reply mode when input is empty', () {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.setReplyingTo(_comment(id: 10, timestampSeconds: 5));

      expect(
        container.read(trackCommentsProvider(1)).activeReplyCommentId,
        isNull,
      );
    });

    test('collapseReplies removes comment id from expandedCommentIds', () {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.setReplyingTo(_comment(id: 10, timestampSeconds: 5));
      expect(
        container
            .read(trackCommentsProvider(1))
            .expandedCommentIds
            .contains(10),
        isTrue,
      );

      notifier.collapseReplies(10);

      expect(
        container
            .read(trackCommentsProvider(1))
            .expandedCommentIds
            .contains(10),
        isFalse,
      );
    });
  });

  group('loadComments', () {
    test('loads only top-level timestamped comments', () async {
      final timestampedTopLevel = _comment(id: 1, timestampSeconds: 10);
      final noTimestamp = _comment(id: 2, timestampSeconds: null);
      final replyComment = _comment(
        id: 3,
        timestampSeconds: 12,
        replyToCommentId: 1,
      );

      when(
        () => repository.getComments(trackId: 1, page: 0, size: 20),
      ).thenAnswer(
        (_) async => Right(
          _paginatedComments([timestampedTopLevel, noTimestamp, replyComment]),
        ),
      );

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadComments();

      final state = container.read(trackCommentsProvider(1));
      expect(state.isLoadingComments, isFalse);
      expect(state.comments.map((comment) => comment.commentid), [1]);
    });

    test('sets isLoadingComments false when repository fails', () async {
      when(
        () => repository.getComments(trackId: 1, page: 0, size: 20),
      ).thenAnswer((_) async => Left(ServerFailure('error')));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadComments();

      final state = container.read(trackCommentsProvider(1));
      expect(state.isLoadingComments, isFalse);
      expect(state.comments, isEmpty);
    });

    test(
      'loadMore requests next page and merges comments without duplicates',
      () async {
        final pageZeroComment = _comment(id: 1, timestampSeconds: 10);
        final pageOneComment = _comment(id: 2, timestampSeconds: 20);

        when(
          () => repository.getComments(trackId: 1, page: 0, size: 20),
        ).thenAnswer(
          (_) async => Right(
            _paginatedComments([pageZeroComment], pageNumber: 0, isLast: false),
          ),
        );

        when(
          () => repository.getComments(trackId: 1, page: 1, size: 20),
        ).thenAnswer(
          (_) async => Right(
            _paginatedComments(
              [pageZeroComment, pageOneComment],
              pageNumber: 1,
              isLast: true,
            ),
          ),
        );

        final container = buildContainer();
        final notifier = container.read(trackCommentsProvider(1).notifier);

        await notifier.loadComments();
        await notifier.loadComments(loadMore: true);

        final state = container.read(trackCommentsProvider(1));
        expect(state.comments.map((comment) => comment.commentid), [2, 1]);
        expect(state.currentCommentsPage, 1);
        expect(state.isLastCommentsPage, isTrue);
      },
    );

    test('does not load more when already on last page', () async {
      when(
        () => repository.getComments(trackId: 1, page: 0, size: 20),
      ).thenAnswer(
        (_) async => Right(
          _paginatedComments([
            _comment(id: 1, timestampSeconds: 10),
          ], isLast: true),
        ),
      );

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadComments();
      await notifier.loadComments(loadMore: true);

      verify(
        () => repository.getComments(trackId: 1, page: 0, size: 20),
      ).called(greaterThanOrEqualTo(1));
      verifyNever(() => repository.getComments(trackId: 1, page: 1, size: 20));
    });
  });

  group('loadReplies', () {
    test('loads first page replies and removes loading id', () async {
      final replies = [
        _reply(id: 100, body: 'reply 1'),
        _reply(id: 101, body: 'reply 2'),
      ];

      when(
        () => repository.getReplies(commentId: 10, page: 0, size: 5),
      ).thenAnswer((_) async => Right(_paginatedReplies(replies)));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadReplies(10);

      final state = container.read(trackCommentsProvider(1));
      expect(state.expandedCommentIds.contains(10), isTrue);
      expect(state.loadingReplyIds.contains(10), isFalse);
      expect(state.repliesByCommentId[10]?.content, replies);
    });

    test('appends next replies page', () async {
      final firstReply = _reply(id: 100, body: 'reply 1');
      final secondReply = _reply(id: 101, body: 'reply 2');

      when(
        () => repository.getReplies(commentId: 10, page: 0, size: 5),
      ).thenAnswer(
        (_) async => Right(
          _paginatedReplies([firstReply], pageNumber: 0, isLast: false),
        ),
      );

      when(
        () => repository.getReplies(commentId: 10, page: 1, size: 5),
      ).thenAnswer(
        (_) async => Right(
          _paginatedReplies([secondReply], pageNumber: 1, isLast: true),
        ),
      );

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadReplies(10);
      await notifier.loadReplies(10, page: 1);

      final replies = container
          .read(trackCommentsProvider(1))
          .repliesByCommentId[10]
          ?.content;

      expect(replies?.map((reply) => reply.commentId), [100, 101]);
    });

    test('rolls back expanded and loading state when replies fail', () async {
      when(
        () => repository.getReplies(commentId: 10, page: 0, size: 5),
      ).thenAnswer((_) async => Left(ServerFailure('error')));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadReplies(10);

      final state = container.read(trackCommentsProvider(1));
      expect(state.expandedCommentIds.contains(10), isFalse);
      expect(state.loadingReplyIds.contains(10), isFalse);
      expect(state.repliesByCommentId[10], isNull);
    });
  });

  group('sorting', () {
    test('changeSortOption sorts by oldest', () async {
      final newer = _comment(
        id: 1,
        timestampSeconds: 20,
        createdAt: DateTime(2026, 1, 2),
      );
      final older = _comment(
        id: 2,
        timestampSeconds: 10,
        createdAt: DateTime(2026, 1, 1),
      );

      when(
        () => repository.getComments(trackId: 1, page: 0, size: 20),
      ).thenAnswer((_) async => Right(_paginatedComments([newer, older])));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadComments();
      notifier.changeSortOption(CommentSortOption.oldest);

      final state = container.read(trackCommentsProvider(1));
      expect(state.sortOption, CommentSortOption.oldest);
      expect(state.comments.map((comment) => comment.commentid), [2, 1]);
    });

    test('changeSortOption sorts by track time', () async {
      final late = _comment(id: 1, timestampSeconds: 50);
      final early = _comment(id: 2, timestampSeconds: 10);

      when(
        () => repository.getComments(trackId: 1, page: 0, size: 20),
      ).thenAnswer((_) async => Right(_paginatedComments([late, early])));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadComments();
      notifier.changeSortOption(CommentSortOption.trackTime);

      final state = container.read(trackCommentsProvider(1));
      expect(state.sortOption, CommentSortOption.trackTime);
      expect(state.comments.map((comment) => comment.commentid), [2, 1]);
    });

    test('changeSortOption does nothing if same option', () {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.changeSortOption(CommentSortOption.newest);

      expect(
        container.read(trackCommentsProvider(1)).sortOption,
        CommentSortOption.newest,
      );
    });
  });

  group('post guards', () {
    test('postComment does nothing when body is empty', () async {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.selectTimestamp(10);
      await notifier.postComment('   ');

      verifyNever(
        () => repository.postComment(
          commentid: any(named: 'commentid'),
          trackId: any(named: 'trackId'),
          body: any(named: 'body'),
          timestampSeconds: any(named: 'timestampSeconds'),
        ),
      );
    });

    test('postComment does nothing when timestamp is null', () async {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.postComment('hello');

      verifyNever(
        () => repository.postComment(
          commentid: any(named: 'commentid'),
          trackId: any(named: 'trackId'),
          body: any(named: 'body'),
          timestampSeconds: any(named: 'timestampSeconds'),
        ),
      );
    });

    test('postReply does nothing when body is empty', () async {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.postReply(10, '   ');

      verifyNever(
        () => repository.postReply(
          commentId: any(named: 'commentId'),
          body: any(named: 'body'),
        ),
      );
    });

    test('handleSubmit does nothing when content is empty', () async {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.handleSubmit('   ');

      verifyNever(
        () => repository.postComment(
          commentid: any(named: 'commentid'),
          trackId: any(named: 'trackId'),
          body: any(named: 'body'),
          timestampSeconds: any(named: 'timestampSeconds'),
        ),
      );
      verifyNever(
        () => repository.postReply(
          commentId: any(named: 'commentId'),
          body: any(named: 'body'),
        ),
      );
    });
  });
}

Comment _comment({
  required int id,
  required int? timestampSeconds,
  int? replyToCommentId,
  DateTime? createdAt,
}) {
  return Comment(
    commentid: id,
    replycount: 0,
    timestampSeconds: timestampSeconds,
    replyToCommentId: replyToCommentId,
    body: 'comment $id',
    createdAt: createdAt ?? DateTime(2026, 1, 1, 12, 0, id),
    user: const CommentUser(id: 1, username: 'tarek', avatarUrl: null),
  );
}

CommentReply _reply({required int id, required String body}) {
  return CommentReply(
    commentId: id,
    body: body,
    createdAt: DateTime(2026, 1, 1),
    user: const CommentUser(id: 1, username: 'tarek', avatarUrl: null),
  );
}

PaginatedComments _paginatedComments(
  List<Comment> comments, {
  int pageNumber = 0,
  int pageSize = 20,
  int totalElements = 0,
  int totalPages = 1,
  bool isLast = true,
}) {
  return PaginatedComments(
    content: comments,
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalElements: totalElements == 0 ? comments.length : totalElements,
    totalPages: totalPages,
    isLast: isLast,
  );
}

PaginatedReplies _paginatedReplies(
  List<CommentReply> replies, {
  int pageNumber = 0,
  int pageSize = 5,
  int totalElements = 0,
  int totalPages = 1,
  bool isLast = true,
}) {
  return PaginatedReplies(
    content: replies,
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalElements: totalElements == 0 ? replies.length : totalElements,
    totalPages: totalPages,
    isLast: isLast,
  );
}
