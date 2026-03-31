import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
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

  @override
  TrackCommentsState build(int trackId) {
    _trackId = trackId;
    _repository = ref.read(commentRepositoryProvider);

    return const TrackCommentsState(
      comments: [],
      isSubmitting: false,
      selectedTimestampSeconds: null,
      isLoadingComments: false,
      isLoadingReplies: false,
      repliesByCommentId: {},
      expandedCommentIds: {},
      deletingCommentId: null,
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
      (comments) {
        final sortedComments = [...comments]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        state = state.copyWith(
          comments: sortedComments,
          isLoadingComments: false,
        );
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

  /// Collapses (hides) replies for a given comment in the UI.
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
  Future<void> deleteComment(int commentId) async {
    state = state.copyWith(deletingCommentId: commentId);

    final previousComments = List<Comment>.from(state.comments);

    state = state.copyWith(
      comments: state.comments.where((c) => c.commentid != commentId).toList(),
    );

    final result = await _repository.deleteComment(commentId: commentId);

    result.fold(
      (failure) {
        state = state.copyWith(
          comments: previousComments,
          deletingCommentId: null,
        );
      },
      (_) {
        final updatedRepliesMap = Map<int, List<CommentReply>>.from(
          state.repliesByCommentId,
        )..remove(commentId);

        final updatedExpandedIds = Set<int>.from(state.expandedCommentIds)
          ..remove(commentId);

        state = state.copyWith(
          repliesByCommentId: updatedRepliesMap,
          expandedCommentIds: updatedExpandedIds,
          deletingCommentId: null,
        );
      },
    );
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

    state = state.copyWith(
      comments: [optimisticComment, ...previousComments],
      isSubmitting: true,
    );

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
        state = state.copyWith(
          comments: state.comments
              .map((c) => c.commentid == tempId ? serverComment : c)
              .toList(),
          isSubmitting: false,
        );
      },
    );
  }
}

/// Provides the comment notifier for a specific track.
/// Key = trackId
final trackCommentsProvider =
    NotifierProvider.family<TrackCommentNotifier, TrackCommentsState, int>(
      TrackCommentNotifier.new,
    );

/// Returns comments that match the current playback timestamp.
///
/// Used to show floating comments on waveform.
/// Filters comments by exact second and sorts them chronologically.
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
