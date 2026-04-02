import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../data/datasources/track_comments_mock_fixtures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/comment_reply.dart';
import '../../domain/entities/comment_user.dart';
import '../../domain/entities/paginated_comment_reply.dart';
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
      currentCommentsPage: 0,
      isLastCommentsPage: false,
    );
  }

  void selectTimestamp(int seconds) {
    state = state.copyWith(selectedTimestampSeconds: seconds);
  }

  /// Fetches comments for the current track from the repository.
  ///
  /// Supports pagination using [page] and [size].
  /// Updates the state with sorted comments (oldest → newest).
  Future<void> loadComments({bool loadMore = false, int size = 20}) async {
    if (state.isLoadingComments || (loadMore && state.isLastCommentsPage)) {
      return;
    }

    final nextPage = loadMore ? state.currentCommentsPage + 1 : 0;
    state = state.copyWith(isLoadingComments: true);

    final result = await _repository.getComments(
      trackId: _trackId,
      page: nextPage,
      size: size,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingComments: false);
      },
      (paginatedComments) {
        final Map<int, Comment> mergedMap = {
          if (loadMore)
            for (var c in state.comments) c.commentid: c,
          for (var c in paginatedComments.content) c.commentid: c,
        };

        final mergedList = mergedMap.values.toList();
        _applySorting(mergedList, state.sortOption);

        state = state.copyWith(
          comments: mergedList,
          currentCommentsPage: paginatedComments.pageNumber ?? 0,
          isLastCommentsPage: paginatedComments.isLast ?? true,
          isLoadingComments: false,
        );
      },
    );
  }

  /// Fetches replies for a specific comment.
  ///
  /// Stores replies in [repliesByCommentId] and marks the comment as expanded
  /// so the UI can display them.
  Future<void> loadReplies(int commentId, {int page = 0, int size = 5}) async {
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
      (paginatedReplies) {
        final updatedRepliesMap = Map<int, PaginatedReplies>.from(
          state.repliesByCommentId,
        );

        if (page == 0) {
          updatedRepliesMap[commentId] = paginatedReplies;
        } else {
          final existingContent = updatedRepliesMap[commentId]?.content ?? [];
          final mergedContent = [
            ...existingContent,
            ...paginatedReplies.content,
          ];

          updatedRepliesMap[commentId] = PaginatedReplies(
            content: mergedContent,
            pageNumber: paginatedReplies.pageNumber,
            pageSize: paginatedReplies.pageSize,
            totalElements: paginatedReplies.totalElements,
            totalPages: paginatedReplies.totalPages,
            isLast: paginatedReplies.isLast,
          );
        }

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

  /// Collapses the reply section for a specific comment.
  void collapseReplies(int commentId) {
    // Remove the comment ID from the set of expanded IDs to hide it in the UI
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
          final updatedRepliesMap = Map<int, PaginatedReplies>.from(
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

  /// Adds a reply to a specific parent comment.
  /// Uses an Optimistic UI approach to show the reply immediately before the server responds.
  Future<void> postReply(int commentId, String body) async {
    // 1. Validation: Prevent empty replies
    if (body.trim().isEmpty) return;

    // 2. Auth Check: Ensure the user is logged in
    final authState = ref.read(authStateProvider).value;
    if (authState is! AuthAuthenticated) return;

    final authUser = authState.user;

    // 3. Generate a temporary ID to identify the optimistic reply in the list
    final tempId = DateTime.now().millisecondsSinceEpoch;

    // 4. Create the temporary Reply object
    final optimisticReply = CommentReply(
      commentId: tempId,
      user: CommentUser(
        id: authUser.id,
        username: authUser.username,
        avatarUrl: authUser.avatarUrl ?? '',
      ),
      body: body.trim(),
      createdAt: DateTime.now(),
    );

    // 5. OPTIMISTIC UPDATE: Show the reply in the UI immediately
    final currentState = state.repliesByCommentId[commentId];
    if (currentState != null) {
      final updatedContent = [...currentState.content, optimisticReply];
      final updatedRepliesMap = Map<int, PaginatedReplies>.from(
        state.repliesByCommentId,
      );

      // Recreate PaginatedReplies manually because the entity lacks copyWith
      updatedRepliesMap[commentId] = PaginatedReplies(
        content: updatedContent,
        pageNumber: currentState.pageNumber,
        pageSize: currentState.pageSize,
        totalElements: (currentState.totalElements ?? 0) + 1,
        totalPages: currentState.totalPages,
        isLast: currentState.isLast,
      );

      state = state.copyWith(repliesByCommentId: updatedRepliesMap);
    }

    // 6. API CALL: Send the reply to the backend
    final result = await _repository.postReply(
      commentId: commentId,
      body: body.trim(),
    );

    result.fold(
      (failure) {
        // 7. FAILURE CASE: Remove the optimistic reply from UI (Rollback)
        final latestState = state.repliesByCommentId[commentId];
        if (latestState != null) {
          // Filter out the reply that matches the tempId
          final rollbackContent = latestState.content
              .where((r) => r.commentId != tempId)
              .toList();

          final updatedRepliesMap = Map<int, PaginatedReplies>.from(
            state.repliesByCommentId,
          );

          updatedRepliesMap[commentId] = PaginatedReplies(
            content: rollbackContent,
            pageNumber: latestState.pageNumber,
            pageSize: latestState.pageSize,
            totalElements: (latestState.totalElements ?? 1) - 1,
            totalPages: latestState.totalPages,
            isLast: latestState.isLast,
          );

          state = state.copyWith(repliesByCommentId: updatedRepliesMap);
        }
      },
      (serverReply) {
        // 8. SUCCESS CASE: Replace the temporary reply with the official server response
        final latestState = state.repliesByCommentId[commentId];
        if (latestState != null) {
          final mergedContent = latestState.content
              .map((r) => r.commentId == tempId ? serverReply : r)
              .toList();

          final updatedRepliesMap = Map<int, PaginatedReplies>.from(
            state.repliesByCommentId,
          );

          updatedRepliesMap[commentId] = PaginatedReplies(
            content: mergedContent,
            pageNumber: latestState.pageNumber,
            pageSize: latestState.pageSize,
            totalElements: latestState.totalElements,
            totalPages: latestState.totalPages,
            isLast: latestState.isLast,
          );

          state = state.copyWith(repliesByCommentId: updatedRepliesMap);

          clearReplyMode();
        }
      },
    );
  }

  /// Sets the state to "Reply Mode" for a specific comment.
  /// Prepares the @username string to be shown in the input field.
  void setReplyingTo(Comment comment) {
    state = state.copyWith(
      activeReplyCommentId: comment.commentid,
      replyPrefillText: '@${comment.user.username} ',
    );

    // Automatically expand the replies section so the user sees the thread context
    loadReplies(comment.commentid);
  }

  /// Resets the reply context.
  /// This should be called after a successful post or if the user cancels the reply.
  // Inside TrackCommentNotifier
  void clearReplyMode() {
    state = TrackCommentsState(
      comments: state.comments,
      selectedTimestampSeconds: state.selectedTimestampSeconds,
      isSubmitting: state.isSubmitting,
      isLoadingComments: state.isLoadingComments,
      isLoadingReplies: state.isLoadingReplies,
      repliesByCommentId: state.repliesByCommentId,
      expandedCommentIds: state.expandedCommentIds,
      deletingCommentId: state.deletingCommentId,
      sortOption: state.sortOption,
      currentCommentsPage: state.currentCommentsPage,
      isLastCommentsPage: state.isLastCommentsPage,
      activeReplyCommentId: null,
      replyPrefillText: null,
    );
  }

  /// Single entry point for the UI to submit text.
  /// Decides between postComment and postReply based on state.
  Future<void> handleSubmit(String content) async {
    if (content.trim().isEmpty) return;

    // 1. Check if we are in Reply Mode
    if (state.activeReplyCommentId != null) {
      await postReply(state.activeReplyCommentId!, content);
      return;
    }

    // 2. Otherwise, handle as a new top-level comment
    // We read the audio state directly here to keep logic out of UI
    final audioState = ref.read(trackAudioProvider);
    final currentSecond = (audioState.duration.inSeconds * audioState.progress)
        .round();

    selectTimestamp(currentSecond);
    await postComment(content);
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
