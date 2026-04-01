import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../data/datasources/track_comments_mock_fixtures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/comment_reply.dart';
import '../../domain/entities/comment_user.dart';
import '../../domain/repositories/i_track_comments_repository.dart';
import '../providers/comments_repository_provider.dart';
import '../state/track_comment_state.dart';

/// Manages all comment-related interactions for a specific track.
///
/// Responsibilities:
/// - Fetching track comments
/// - Posting new comments (with optimistic updates)
/// - Loading replies for a comment
/// - Deleting comments
/// - Filtering active comments based on current playback time
class TrackCommentNotifier extends FamilyNotifier<TrackCommentsState, int> {
  late final int _trackId;
  late final ITrackCommentsRepository _repository;
  final Set<int> _cancelledDeletions = {};

  @override
  TrackCommentsState build(int trackId) {
    _trackId = trackId;
    _repository = ref.read(commentRepositoryProvider);

    final fixtureComment = TrackCommentsMockFixtures.mockTrackComments.first;

    final initialTestComment = Comment(
      commentid: fixtureComment.commentId,
      timestampSeconds: fixtureComment.timestampSeconds,
      body: fixtureComment.body,
      createdAt: fixtureComment.createdAt,
      replycount: fixtureComment.replycount,
      user: CommentUser(
        id: fixtureComment.user.id,
        username: fixtureComment.user.username,
        avatarUrl: fixtureComment.user.avatarUrl,
      ),
    );

    return TrackCommentsState(
      comments: [initialTestComment],
      isSubmitting: false,
      selectedTimestampSeconds: null,
      isLoadingComments: false,
      isLoadingReplies: false,
      repliesByCommentId: {},
      expandedCommentIds: {},
      deletingCommentId: null,
      sortOption: CommentSortOption.newest,
    );
  }

  /// Selects the timestamp (in seconds) where the user wants to comment.
  /// Triggered when the user taps on the waveform.
  void selectTimestamp(int seconds) {
    state = state.copyWith(selectedTimestampSeconds: seconds);
  }

  /// Fetches comments for the current track from the repository.
  ///
  /// Supports pagination using [page] and [size].
  /// Updates the state with sorted comments (oldest → newest).
  Future<void> loadComments({int page = 0, int size = 20}) async {
    state = state.copyWith(isLoadingComments: true);

    final result = await _repository.getComments(
      trackId: _trackId,
      page: page,
      size: size,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingComments: false);
      },
      (newComments) {
        final Map<int, Comment> mergedMap = {
          for (var c in state.comments) c.commentid: c,
          for (var c in newComments) c.commentid: c,
        };

        final mergedList = mergedMap.values.toList();
        _applySorting(mergedList, state.sortOption);

        state = state.copyWith(comments: mergedList, isLoadingComments: false);
      },
    );
  }

  /// Fetches replies for a specific comment.
  ///
  /// Stores replies in [repliesByCommentId] and marks the comment as expanded
  /// so the UI can display them.
  Future<void> loadReplies(int commentId, {int page = 0, int size = 20}) async {
    state = state.copyWith(isLoadingReplies: true);

    final result = await _repository.getReplies(
      commentId: commentId,
      page: page,
      size: size,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingReplies: false);
      },
      (replies) {
        final updatedRepliesMap = Map<int, List<CommentReply>>.from(
          state.repliesByCommentId,
        );

        updatedRepliesMap[commentId] = replies;

        final updatedExpandedIds = Set<int>.from(state.expandedCommentIds)
          ..add(commentId);

        state = state.copyWith(
          repliesByCommentId: updatedRepliesMap,
          expandedCommentIds: updatedExpandedIds,
          isLoadingReplies: false,
        );
      },
    );
  }

  void collapseReplies(int commentId) {
    final updatedExpandedIds = Set<int>.from(state.expandedCommentIds)
      ..remove(commentId);

    state = state.copyWith(expandedCommentIds: updatedExpandedIds);
  }

  /// Deletes a comment optimistically.
  ///
  /// - Removes the comment immediately from UI
  /// - Calls the API
  /// - Restores previous state if the request fails
  void requestDeletion(Comment comment, Duration undoDelay) {
    state = state.copyWith(
      comments: state.comments
          .where((c) => c.commentid != comment.commentid)
          .toList(),
    );

    Future.delayed(undoDelay, () async {
      if (_cancelledDeletions.contains(comment.commentid)) {
        _cancelledDeletions.remove(comment.commentid);
        return;
      }

      state = state.copyWith(deletingCommentId: comment.commentid);

      final result = await _repository.deleteComment(
        commentId: comment.commentid,
      );

      result.fold(
        (failure) {
          restoreComment(comment);
          state = state.copyWith(deletingCommentId: null);
        },
        (_) {
          final updatedRepliesMap = Map<int, List<CommentReply>>.from(
            state.repliesByCommentId,
          )..remove(comment.commentid);

          final updatedExpandedIds = Set<int>.from(state.expandedCommentIds)
            ..remove(comment.commentid);

          state = state.copyWith(
            repliesByCommentId: updatedRepliesMap,
            expandedCommentIds: updatedExpandedIds,
            deletingCommentId: null,
          );
        },
      );
    });
  }

  void undoDeletion(Comment comment) {
    _cancelledDeletions.add(comment.commentid);
    restoreComment(comment);
  }

  /// Posts a new comment with optimistic UI update.
  ///
  /// Flow:
  /// 1. Creates a temporary comment (optimistic)
  /// 2. Adds it to UI immediately
  /// 3. Sends request to backend
  /// 4. Replaces temp comment with server response OR rolls back on failure
  Future<void> postComment(String body) async {
    final selectedTimestamp = state.selectedTimestampSeconds;
    if (body.trim().isEmpty || selectedTimestamp == null) return;

    final authState = ref.read(authStateProvider).value;
    if (authState is! AuthAuthenticated) {
      state = state.copyWith(isSubmitting: false);
      return;
    }

    final authUser = authState.user;
    final tempId = DateTime.now().millisecondsSinceEpoch;

    final optimisticComment = Comment(
      replycount: 0,
      commentid: tempId,
      timestampSeconds: selectedTimestamp,
      body: body.trim(),
      createdAt: DateTime.now(),
      user: CommentUser(
        id: authUser.id,
        username: authUser.username,
        avatarUrl: authUser.avatarUrl!.isNotEmpty ? authUser.avatarUrl : '',
      ),
    );

    final previousComments = state.comments;
    final newList = [optimisticComment, ...previousComments];
    _applySorting(newList, state.sortOption);

    state = state.copyWith(comments: newList, isSubmitting: true);

    final result = await _repository.postComment(
      commentid: tempId,
      trackId: _trackId,
      body: body.trim(),
      timestampSeconds: selectedTimestamp,
    );

    result.fold(
      (failure) {
        state = state.copyWith(comments: previousComments, isSubmitting: false);
      },
      (serverComment) {
        final mergedList = state.comments
            .map((c) => c.commentid == tempId ? serverComment : c)
            .toList();
        _applySorting(mergedList, state.sortOption);

        state = state.copyWith(comments: mergedList, isSubmitting: false);
      },
    );
  }

  /// Restores a deleted comment (Undo feature)
  void restoreComment(Comment comment) {
    if (state.comments.any((c) => c.commentid == comment.commentid)) return;

    final updatedList = [...state.comments, comment];
    _applySorting(updatedList, state.sortOption);

    state = state.copyWith(comments: updatedList);
  }

  void changeSortOption(CommentSortOption newOption) {
    if (state.sortOption == newOption) return;

    final sortedList = List<Comment>.from(state.comments);
    _applySorting(sortedList, newOption);

    state = state.copyWith(sortOption: newOption, comments: sortedList);
  }

  void _applySorting(List<Comment> list, CommentSortOption option) {
    switch (option) {
      case CommentSortOption.newest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case CommentSortOption.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case CommentSortOption.trackTime:
        list.sort(
          (a, b) =>
              (a.timestampSeconds ?? 0).compareTo(b.timestampSeconds ?? 0),
        );
        break;
    }
  }
}

final trackCommentsProvider =
    NotifierProvider.family<TrackCommentNotifier, TrackCommentsState, int>(
      TrackCommentNotifier.new,
    );

final currentActiveCommentsProvider = Provider.family<List<Comment>, int>((
  ref,
  trackId,
) {
  final audioState = ref.watch(trackAudioProvider);

  final currentSecond = (audioState.duration.inSeconds * audioState.progress)
      .round();

  final commentsState = ref.watch(trackCommentsProvider(trackId));

  final activeComments = commentsState.comments
      .where((c) => c.timestampSeconds == currentSecond)
      .toList();

  activeComments.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  return activeComments;
});
