import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/library/domain/entities/comment.dart';
import 'package:decibel/features/library/domain/entities/comment_reply.dart';
import 'package:decibel/features/library/domain/entities/comment_user.dart';
import 'package:decibel/features/library/domain/entities/paginated_comment_reply.dart';
import 'package:decibel/features/library/domain/entities/paginated_comments.dart';
import 'package:decibel/features/library/domain/repositories/i_track_comments_repository.dart';
import 'package:decibel/features/library/presentation/providers/comments_repository_provider.dart';
import 'package:decibel/features/library/presentation/providers/track_comment_provider.dart';
import 'package:decibel/features/library/presentation/state/track_comment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackCommentsRepository extends Mock
    implements ITrackCommentsRepository {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(this.authState);

  final AuthState authState;

  @override
  FutureOr<AuthState> build() => authState;
}

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

  ProviderContainer buildContainer({
    AuthState authState = const AuthUnauthenticated(),
  }) {
    final container = ProviderContainer(
      overrides: [
        commentRepositoryProvider.overrideWithValue(repository),
        authStateProvider.overrideWith(() => FakeAuthNotifier(authState)),
      ],
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

    test(
      'active comment helpers return comments at the requested second',
      () async {
        final later = _comment(
          id: 1,
          timestampSeconds: 12,
          createdAt: DateTime(2026, 1, 1, 12, 0, 2),
        );
        final earlier = _comment(
          id: 2,
          timestampSeconds: 12,
          createdAt: DateTime(2026, 1, 1, 12, 0, 1),
        );
        final otherSecond = _comment(id: 3, timestampSeconds: 30);

        when(
          () => repository.getComments(trackId: 1, page: 0, size: 20),
        ).thenAnswer(
          (_) async => Right(_paginatedComments([later, earlier, otherSecond])),
        );

        final container = buildContainer();
        final notifier = container.read(trackCommentsProvider(1).notifier);

        await notifier.loadComments();

        expect(
          notifier
              .activeCommentsForSecond(12)
              .map((comment) => comment.commentid),
          [2, 1],
        );
        expect(notifier.activeCommentForSecond(12)?.commentid, 2);
        expect(notifier.activeCommentForSecond(99), isNull);
      },
    );
  });

  group('comment ownership', () {
    test('canManageComment returns true for own authenticated comment', () {
      final comment = _comment(id: 10, timestampSeconds: 5, userId: 7);
      final container = buildContainer(
        authState: const AuthAuthenticated(user: _authUser),
      );
      final notifier = container.read(trackCommentsProvider(1).notifier);

      expect(notifier.canManageComment(comment), isTrue);
    });

    test('canManageComment returns false for another user', () {
      final comment = _comment(id: 10, timestampSeconds: 5, userId: 99);
      final container = buildContainer(
        authState: const AuthAuthenticated(user: _authUser),
      );
      final notifier = container.read(trackCommentsProvider(1).notifier);

      expect(notifier.canManageComment(comment), isFalse);
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

    test(
      'clearReplyModeIfInputIsEmpty keeps reply mode for nonempty input',
      () {
        final container = buildContainer();
        final notifier = container.read(trackCommentsProvider(1).notifier);

        notifier.setReplyingTo(_comment(id: 10, timestampSeconds: 5));
        notifier.clearReplyModeIfInputIsEmpty('reply body');

        expect(
          container.read(trackCommentsProvider(1)).activeReplyCommentId,
          10,
        );
      },
    );

    test('clearReplyModeIfInputIsEmpty clears reply mode for empty input', () {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.setReplyingTo(_comment(id: 10, timestampSeconds: 5));
      notifier.clearReplyModeIfInputIsEmpty('');

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

    test('reply helper methods reflect loaded reply state', () async {
      final comment = _comment(id: 10, timestampSeconds: 5, replycount: 2);
      final reply = _reply(id: 100, body: 'reply 1');

      when(
        () => repository.getReplies(commentId: 10, page: 0, size: 5),
      ).thenAnswer((_) async => Right(_paginatedReplies([reply])));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      final loadFuture = notifier.loadReplies(10);
      expect(notifier.isRepliesExpanded(comment), isTrue);
      expect(notifier.isLoadingReplies(comment), isTrue);
      expect(notifier.isInitialRepliesLoading(comment), isTrue);

      await loadFuture;

      expect(notifier.paginatedRepliesFor(comment), isNotNull);
      expect(notifier.repliesFor(comment), [reply]);
      expect(notifier.isLoadingReplies(comment), isFalse);
      expect(notifier.isInitialRepliesLoading(comment), isFalse);
      expect(notifier.isPaginatingReplies(comment), isFalse);
      expect(notifier.hasRepliesToFetch(comment), isTrue);
      expect(notifier.nextRepliesPage(comment), 1);

      final nextPageFuture = notifier.loadReplies(10, page: 1);
      expect(notifier.isPaginatingReplies(comment), isTrue);
      await nextPageFuture;
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
      ).thenAnswer((_) async => const Left(ServerFailure('error')));

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
      ).thenAnswer((_) async => const Left(ServerFailure('error')));

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

    test('postComment does nothing for unauthenticated user', () async {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      notifier.selectTimestamp(10);
      await notifier.postComment('hello');

      verifyNever(
        () => repository.postComment(
          commentid: any(named: 'commentid'),
          trackId: any(named: 'trackId'),
          body: any(named: 'body'),
          timestampSeconds: any(named: 'timestampSeconds'),
        ),
      );
      expect(container.read(trackCommentsProvider(1)).isSubmitting, isFalse);
    });

    test('postReply does nothing for unauthenticated user', () async {
      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.postReply(10, 'hello');

      verifyNever(
        () => repository.postReply(
          commentId: any(named: 'commentId'),
          body: any(named: 'body'),
        ),
      );
    });
  });

  group('postComment', () {
    test(
      'adds optimistic comment and replaces it with server comment',
      () async {
        final serverComment = _comment(
          id: 500,
          timestampSeconds: 10,
          body: 'hello',
          userId: _authUser.id,
        );

        when(
          () => repository.postComment(
            commentid: any(named: 'commentid'),
            trackId: 1,
            body: 'hello',
            timestampSeconds: 10,
          ),
        ).thenAnswer((_) async => Right(serverComment));

        final container = buildContainer(
          authState: const AuthAuthenticated(user: _authUser),
        );
        final notifier = container.read(trackCommentsProvider(1).notifier);

        notifier.selectTimestamp(10);
        await notifier.postComment(' hello ');

        final state = container.read(trackCommentsProvider(1));
        expect(state.isSubmitting, isFalse);
        expect(state.comments.single.commentid, 500);
        expect(state.comments.single.body, 'hello');
      },
    );

    test('rolls back optimistic comment when repository fails', () async {
      final existing = _comment(id: 1, timestampSeconds: 4);

      when(
        () => repository.getComments(trackId: 1, page: 0, size: 20),
      ).thenAnswer((_) async => Right(_paginatedComments([existing])));

      when(
        () => repository.postComment(
          commentid: any(named: 'commentid'),
          trackId: 1,
          body: 'hello',
          timestampSeconds: 10,
        ),
      ).thenAnswer((_) async => const Left(ServerFailure('failed')));

      final container = buildContainer(
        authState: const AuthAuthenticated(user: _authUser),
      );
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadComments();
      notifier.selectTimestamp(10);
      await notifier.postComment('hello');

      final state = container.read(trackCommentsProvider(1));
      expect(state.isSubmitting, isFalse);
      expect(state.comments.map((comment) => comment.commentid), [1]);
    });
  });

  group('postReply', () {
    test('adds optimistic reply and replaces it with server reply', () async {
      final serverReply = _reply(id: 800, body: 'reply');

      when(
        () => repository.getReplies(commentId: 10, page: 0, size: 5),
      ).thenAnswer((_) async => Right(_paginatedReplies([])));
      when(
        () => repository.postReply(commentId: 10, body: 'reply'),
      ).thenAnswer((_) async => Right(serverReply));

      final container = buildContainer(
        authState: const AuthAuthenticated(user: _authUser),
      );
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadReplies(10);
      await notifier.postReply(10, ' reply ');

      final state = container.read(trackCommentsProvider(1));
      expect(state.repliesByCommentId[10]?.content.single.commentId, 800);
      expect(state.activeReplyCommentId, isNull);
    });

    test('rolls back optimistic reply when repository fails', () async {
      final existingReply = _reply(id: 100, body: 'old reply');

      when(
        () => repository.getReplies(commentId: 10, page: 0, size: 5),
      ).thenAnswer((_) async => Right(_paginatedReplies([existingReply])));
      when(
        () => repository.postReply(commentId: 10, body: 'reply'),
      ).thenAnswer((_) async => const Left(ServerFailure('failed')));

      final container = buildContainer(
        authState: const AuthAuthenticated(user: _authUser),
      );
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await notifier.loadReplies(10);
      await notifier.postReply(10, 'reply');

      final replies = container
          .read(trackCommentsProvider(1))
          .repliesByCommentId[10]
          ?.content;
      expect(replies?.map((reply) => reply.commentId), [100]);
    });
  });

  group('deletion', () {
    test('requestDeletion commits deletion after undo delay', () async {
      final comment = _comment(id: 10, timestampSeconds: 5, replycount: 1);

      when(
        () => repository.getReplies(commentId: 10, page: 0, size: 5),
      ).thenAnswer((_) async => Right(_paginatedReplies([])));
      when(
        () => repository.deleteComment(commentId: 10),
      ).thenAnswer((_) async => const Right(null));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await Future<void>.delayed(Duration.zero);
      notifier.restoreComment(comment);
      await notifier.loadReplies(10);
      notifier.requestDeletion(comment, Duration.zero);
      await untilCalled(() => repository.deleteComment(commentId: 10));
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final state = container.read(trackCommentsProvider(1));
      expect(state.comments, isEmpty);
      expect(state.repliesByCommentId[10], isNull);
      expect(state.expandedCommentIds.contains(10), isFalse);
      expect(state.deletingCommentId, isNull);
      verify(() => repository.deleteComment(commentId: 10)).called(1);
    });

    test('requestDeletion restores comment when repository fails', () async {
      final comment = _comment(id: 10, timestampSeconds: 5);

      when(
        () => repository.deleteComment(commentId: 10),
      ).thenAnswer((_) async => const Left(ServerFailure('failed')));

      final container = buildContainer();
      final notifier = container.read(trackCommentsProvider(1).notifier);

      await Future<void>.delayed(Duration.zero);
      notifier.restoreComment(comment);
      notifier.requestDeletion(comment, Duration.zero);
      await untilCalled(() => repository.deleteComment(commentId: 10));
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final state = container.read(trackCommentsProvider(1));
      expect(state.comments.single.commentid, 10);
      expect(state.deletingCommentId, isNull);
    });

    test(
      'undoDeletion cancels pending deletion and restores comment',
      () async {
        final comment = _comment(id: 10, timestampSeconds: 5);

        when(
          () => repository.deleteComment(commentId: 10),
        ).thenAnswer((_) async => const Right(null));

        final container = buildContainer();
        final notifier = container.read(trackCommentsProvider(1).notifier);

        await Future<void>.delayed(Duration.zero);
        notifier.restoreComment(comment);
        notifier.requestDeletion(comment, Duration.zero);
        notifier.undoDeletion(comment);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(
          container.read(trackCommentsProvider(1)).comments.single,
          comment,
        );
        verifyNever(() => repository.deleteComment(commentId: 10));
      },
    );
  });
}

Comment _comment({
  required int id,
  required int? timestampSeconds,
  int? replyToCommentId,
  DateTime? createdAt,
  String? body,
  int replycount = 0,
  int userId = 1,
}) {
  return Comment(
    commentid: id,
    replycount: replycount,
    timestampSeconds: timestampSeconds,
    replyToCommentId: replyToCommentId,
    body: body ?? 'comment $id',
    createdAt: createdAt ?? DateTime(2026, 1, 1, 12, 0, id),
    user: CommentUser(id: userId, username: 'tarek', avatarUrl: null),
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

const _authUser = AuthUser(
  id: 7,
  username: 'tarek',
  tier: UserTier.artist,
  avatarUrl: 'https://example.com/avatar.png',
);

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
