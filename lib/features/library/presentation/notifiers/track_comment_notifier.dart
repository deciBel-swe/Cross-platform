import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
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
  static const deleteUndoDelay = Duration(seconds: 4);

  late final int _trackId;
  late final ITrackCommentsRepository _repository;
  final Set<int> _cancelledDeletions = {};

  /// Builds the initial comment state for the requested track.
  @override
  TrackCommentsState build(int trackId) {
    _trackId = trackId;
    _repository = ref.read(commentRepositoryProvider);

    Future.delayed(Duration.zero, () => loadComments());
    return const TrackCommentsState(
      comments: [],
      isSubmitting: false,
      selectedTimestampSeconds: null,
      isLoadingComments: false,
      loadingReplyIds: {},
      repliesByCommentId: {},
      expandedCommentIds: {},
      deletingCommentId: null,
      sortOption: CommentSortOption.newest,
      currentCommentsPage: 0,
      isLastCommentsPage: false,
    );
  }

  /// Stores the timestamp that the next top-level comment should use.
  void selectTimestamp(int seconds) {
    state = state.copyWith(selectedTimestampSeconds: seconds);
  }

  /// Stores the current playback position as the next comment timestamp.
  void selectCurrentPlaybackTimestamp() {
    selectTimestamp(currentPlaybackSecond());
  }

  /// Returns the current playback position rounded to the nearest second.
  int currentPlaybackSecond() {
    final audioState = ref.read(trackAudioProvider);
    return (audioState.duration.inSeconds * audioState.progress).round();
  }

  /// Seeks playback to the timestamp attached to [comment].
  Future<void> seekToComment(Comment comment) async {
    final timestampSeconds = comment.timestampSeconds ?? 0;
    await ref
        .read(trackAudioProvider.notifier)
        .seek(Duration(seconds: timestampSeconds));
  }

  /// Returns whether the authenticated user can manage [comment].
  bool canManageComment(Comment comment) {
    final authState = ref.read(authStateProvider).value;
    return authState is AuthAuthenticated &&
        authState.user.id == comment.user.id;
  }

  /// Clears reply mode once the input becomes empty.
  void clearReplyModeIfInputIsEmpty(String text) {
    if (text.trim().isNotEmpty || state.activeReplyCommentId == null) {
      return;
    }

    clearReplyMode();
  }

  /// Returns comments that should be shown at [currentSecond].
  List<Comment> activeCommentsForSecond(int currentSecond) {
    final activeComments = state.comments
        .where((comment) => comment.timestampSeconds == currentSecond)
        .toList();

    activeComments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return activeComments;
  }

  /// Returns the first active comment at [currentSecond], if any.
  Comment? activeCommentForSecond(int currentSecond) {
    final activeComments = activeCommentsForSecond(currentSecond);
    return activeComments.isEmpty ? null : activeComments.first;
  }

  /// Returns whether replies are expanded for [comment].
  bool isRepliesExpanded(Comment comment) {
    return state.expandedCommentIds.contains(comment.commentid);
  }

  /// Returns the current paginated replies for [comment].
  PaginatedReplies? paginatedRepliesFor(Comment comment) {
    return state.repliesByCommentId[comment.commentid];
  }

  /// Returns replies already loaded for [comment].
  List<CommentReply> repliesFor(Comment comment) {
    return paginatedRepliesFor(comment)?.content ?? const [];
  }

  /// Returns whether replies are currently loading for [comment].
  bool isLoadingReplies(Comment comment) {
    return state.loadingReplyIds.contains(comment.commentid);
  }

  /// Returns whether the first page of replies is loading for [comment].
  bool isInitialRepliesLoading(Comment comment) {
    return isLoadingReplies(comment) &&
        isRepliesExpanded(comment) &&
        repliesFor(comment).isEmpty;
  }

  /// Returns whether another page of replies is loading for [comment].
  bool isPaginatingReplies(Comment comment) {
    return isLoadingReplies(comment) &&
        isRepliesExpanded(comment) &&
        repliesFor(comment).isNotEmpty;
  }

  /// Returns whether [comment] has replies available locally or remotely.
  bool hasRepliesToFetch(Comment comment) {
    return comment.replycount > 0 || repliesFor(comment).isNotEmpty;
  }

  /// Returns the next replies page to load for [comment].
  int nextRepliesPage(Comment comment) {
    return (paginatedRepliesFor(comment)?.pageNumber ?? 0) + 1;
  }

  /// Fetches comments and treats everything from the API as a top-level comment.
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
        final topLevelComments = paginatedComments.content.where((c) {
          if (c.timestampSeconds == null) {
            return false;
          }
          if (c.replyToCommentId != null && c.replyToCommentId != 0) {
            return false;
          }
          return true;
        }).toList();

        final Map<int, Comment> mergedMap = {
          if (loadMore)
            for (var c in state.comments) c.commentid: c,
          for (var c in topLevelComments) c.commentid: c,
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

  /// Fetches replies for a specific comment and expands the thread.
  ///
  /// Stores replies in [repliesByCommentId] and marks the comment as expanded
  /// so the UI can display them.
  /// Fetches replies for a specific comment.

  Future<void> loadReplies(int commentId, {int page = 0, int size = 5}) async {
    final loadingExpandedIds = Set<int>.from(state.expandedCommentIds)
      ..add(commentId);
    final currentLoadingIds = Set<int>.from(state.loadingReplyIds)
      ..add(commentId);

    state = state.copyWith(
      loadingReplyIds: currentLoadingIds,
      expandedCommentIds: loadingExpandedIds,
    );

    final result = await _repository.getReplies(
      commentId: commentId,
      page: page,
      size: size,
    );

    result.fold(
      (failure) {
        final rollbackExpandedIds = Set<int>.from(state.expandedCommentIds)
          ..remove(commentId);
        final stopLoadingIds = Set<int>.from(state.loadingReplyIds)
          ..remove(commentId);

        state = state.copyWith(
          loadingReplyIds: stopLoadingIds,
          expandedCommentIds: rollbackExpandedIds,
        );
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

        final stopLoadingIds = Set<int>.from(state.loadingReplyIds)
          ..remove(commentId);

        state = state.copyWith(
          repliesByCommentId: updatedRepliesMap,
          loadingReplyIds: stopLoadingIds,
        );
      },
    );
  }

  /// Collapses the reply section for a specific comment.
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

  /// Cancels a pending deletion and restores [comment].
  void undoDeletion(Comment comment) {
    _cancelledDeletions.add(comment.commentid);
    restoreComment(comment);
  }

  /// Adds a reply to a specific parent comment.
  /// Uses an Optimistic UI approach to show the reply immediately before the server responds.
  Future<void> postReply(int commentId, String body) async {
    if (body.trim().isEmpty) return;

    final authState = ref.read(authStateProvider).value;
    if (authState is! AuthAuthenticated) return;

    final authUser = authState.user;

    final tempId = DateTime.now().millisecondsSinceEpoch;

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

    final currentState = state.repliesByCommentId[commentId];
    if (currentState != null) {
      final updatedContent = [...currentState.content, optimisticReply];
      final updatedRepliesMap = Map<int, PaginatedReplies>.from(
        state.repliesByCommentId,
      );

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

    final result = await _repository.postReply(
      commentId: commentId,
      body: body.trim(),
    );

    result.fold(
      (failure) {
        final latestState = state.repliesByCommentId[commentId];
        if (latestState != null) {
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
  void setReplyingTo(Comment comment) {
    state = state.copyWith(activeReplyCommentId: comment.commentid);

    loadReplies(comment.commentid);
  }

  /// Resets the reply context.
  void clearReplyMode() {
    state = TrackCommentsState(
      comments: state.comments,
      selectedTimestampSeconds: state.selectedTimestampSeconds,
      isSubmitting: state.isSubmitting,
      isLoadingComments: state.isLoadingComments,
      loadingReplyIds: state.loadingReplyIds,
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
  Future<void> handleSubmit(String content) async {
    if (content.trim().isEmpty) return;

    if (state.activeReplyCommentId != null) {
      await postReply(state.activeReplyCommentId!, content);
      return;
    }

    selectCurrentPlaybackTimestamp();
    await postComment(content);
  }

  /// Posts a new comment with optimistic UI update.
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

    final avatarUrl = authUser.avatarUrl?.isNotEmpty == true
        ? authUser.avatarUrl
        : null;

    final optimisticComment = Comment(
      replycount: 0,
      commentid: tempId,
      timestampSeconds: selectedTimestamp,
      body: body.trim(),
      createdAt: DateTime.now(),
      user: CommentUser(
        id: authUser.id,
        username: authUser.username,
        avatarUrl: avatarUrl,
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

  /// Restores a deleted comment.
  void restoreComment(Comment comment) {
    if (state.comments.any((c) => c.commentid == comment.commentid)) return;

    final updatedList = [...state.comments, comment];
    _applySorting(updatedList, state.sortOption);

    state = state.copyWith(comments: updatedList);
  }

  /// Applies the selected sort option to the current comment list.
  void changeSortOption(CommentSortOption newOption) {
    if (state.sortOption == newOption) return;

    final sortedList = List<Comment>.from(state.comments);
    _applySorting(sortedList, newOption);

    state = state.copyWith(sortOption: newOption, comments: sortedList);
  }

  /// Sorts [list] according to [option].
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
