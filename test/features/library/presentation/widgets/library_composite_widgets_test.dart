import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/comment.dart';
import 'package:decibel/features/library/domain/entities/comment_reply.dart';
import 'package:decibel/features/library/domain/entities/comment_user.dart';
import 'package:decibel/features/library/domain/entities/paginated_comment_reply.dart';
import 'package:decibel/features/library/domain/entities/paginated_comments.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library/domain/repositories/i_track_comments_repository.dart';
import 'package:decibel/features/library/presentation/providers/comments_repository_provider.dart';
import 'package:decibel/features/library/presentation/providers/track_comment_provider.dart';
import 'package:decibel/features/library/presentation/widgets/comment_replies_section.dart';
import 'package:decibel/features/library/presentation/widgets/comment_reply_item.dart';
import 'package:decibel/features/library/presentation/widgets/track_comment_options_sheet.dart';
import 'package:decibel/features/library/presentation/widgets/track_comments_context_tile.dart';
import 'package:decibel/features/library/presentation/widgets/track_comments_header.dart';
import 'package:decibel/features/library/presentation/widgets/track_more_options_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget app(
    Widget child, {
    ITrackCommentsRepository? commentsRepository,
    Size size = const Size(390, 844),
  }) {
    return ProviderScope(
      overrides: [
        if (commentsRepository != null)
          commentRepositoryProvider.overrideWithValue(commentsRepository),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  testWidgets('TrackCommentsContextTile renders track and artist text', (
    tester,
  ) async {
    await tester.pumpWidget(app(TrackCommentsContextTile(track: _track())));

    expect(find.text('Track 1'), findsOneWidget);
    expect(find.text('Artist'), findsOneWidget);
    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets('CommentReplyItem renders Just now when reply has no date', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        CommentReplyItem(
          reply: CommentReply(commentId: 1, user: _user, body: 'reply body'),
        ),
      ),
    );

    expect(find.text('reply body'), findsOneWidget);
    expect(find.text('Just now'), findsOneWidget);
  });

  testWidgets('showTrackCommentOptionsSheet returns true for delete', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                result = await showTrackCommentOptionsSheet(
                  context,
                  Theme.of(context),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete comment'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('showTrackMoreOptionsMenu returns selected desktop option', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    TrackMoreOption? option;

    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                option = await showTrackMoreOptionsMenu(
                  context: context,
                  includeEdit: true,
                  includeDelete: true,
                );
              },
              child: const Text('open menu'),
            );
          },
        ),
        size: const Size(1200, 1000),
      ),
    );

    await tester.tap(find.text('open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy link'));
    await tester.pumpAndSettle();

    expect(option, TrackMoreOption.copyLink);
  });

  testWidgets('TrackCommentsHeader changes sort option from menu', (
    tester,
  ) async {
    final repository = FakeCommentsRepository();

    await tester.pumpWidget(
      app(
        const TrackCommentsHeader(trackId: 1, commentCount: 2),
        commentsRepository: repository,
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oldest'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(TrackCommentsHeader)),
    );
    expect(container.read(trackCommentsProvider(1)).sortOption.name, 'oldest');
  });

  testWidgets('CommentRepliesSection loads and displays replies', (
    tester,
  ) async {
    final repository = FakeCommentsRepository(
      replies: [
        CommentReply(
          commentId: 10,
          user: _user,
          body: 'loaded reply',
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
    );
    final comment = _comment(replycount: 1);

    await tester.pumpWidget(
      app(
        CommentRepliesSection(comment: comment, trackId: 1),
        commentsRepository: repository,
      ),
    );
    await tester.pump();

    expect(find.text('Show replies'), findsOneWidget);
    await tester.tap(find.text('Show replies'));
    await tester.pumpAndSettle();

    expect(find.text('loaded reply'), findsOneWidget);
    expect(find.text('Hide replies'), findsOneWidget);
  });
}

const _user = CommentUser(id: 1, username: 'tarek', avatarUrl: null);

Comment _comment({int replycount = 0}) {
  return Comment(
    commentid: 1,
    replycount: replycount,
    timestampSeconds: 12,
    body: 'comment body',
    createdAt: DateTime(2026, 1, 1),
    user: _user,
  );
}

Track _track() {
  return Track(
    id: 1,
    title: 'Track 1',
    artist: const Artist(id: 1, username: 'artist', displayName: 'Artist'),
    trackUrl: 'https://example.com/audio.mp3',
    genre: 'Pop',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2026, 1, 1),
    playCount: 0,
    likeCount: 0,
    repostCount: 0,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2026, 1, 1),
  );
}

class FakeCommentsRepository implements ITrackCommentsRepository {
  FakeCommentsRepository({this.replies = const []});

  final List<CommentReply> replies;

  @override
  Future<Either<Failure, PaginatedComments>> getComments({
    required int trackId,
    int page = 0,
    int size = 20,
  }) async {
    return Right(
      PaginatedComments(
        content: [_comment(replycount: replies.length)],
        pageNumber: page,
        pageSize: size,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedReplies>> getReplies({
    required int commentId,
    int page = 0,
    int size = 20,
  }) async {
    return Right(
      PaginatedReplies(
        content: replies,
        pageNumber: page,
        pageSize: size,
        totalElements: replies.length,
        totalPages: 1,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, Comment>> postComment({
    int? commentid,
    required int trackId,
    required String body,
    int? timestampSeconds,
  }) async {
    return Right(_comment());
  }

  @override
  Future<Either<Failure, CommentReply>> postReply({
    required int commentId,
    required String body,
  }) async {
    return Right(CommentReply(commentId: 99, user: _user, body: body));
  }

  @override
  Future<Either<Failure, void>> deleteComment({required int commentId}) async {
    return const Right(null);
  }
}
