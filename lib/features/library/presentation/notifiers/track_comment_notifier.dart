import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/comment_user.dart';
import '../../domain/repositories/i_track_comments_repository.dart';
import '../providers/comments_repository_provider.dart';
import '../state/track_comment_state.dart';

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
    );
  }

  void selectTimestamp(int seconds) {
    state = state.copyWith(selectedTimestampSeconds: seconds);
  }

  Future<void> postComment(String body) async {
    final selectedTimestamp = state.selectedTimestampSeconds;
    if (body.trim().isEmpty || selectedTimestamp == null) return;

    // 1. Get current user from Auth State
    final authState = ref.read(authStateProvider).value;
    if (authState is! AuthAuthenticated) {
      state = state.copyWith(isSubmitting: false);
      return;
    }

    final authUser = authState.user;
    final tempId = DateTime.now().millisecondsSinceEpoch;

    // Use avatarUrl only when non-null and non-empty
    final avatarUrl =
        authUser.avatarUrl?.isNotEmpty == true ? authUser.avatarUrl : null;

    final optimisticComment = Comment(
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

    // 3. Update UI Optimistically
    final previousComments = state.comments;
    state = state.copyWith(
      comments: [optimisticComment, ...previousComments],
      isSubmitting: true,
    );

    // 4. Call Repository
    final result = await _repository.postComment(
      commentid: tempId,
      trackId: _trackId,
      body: body.trim(),
      timestampSeconds: selectedTimestamp,
    );

    result.fold(
      (failure) {
        // ROLLBACK: Revert to previous list if server fails
        state = state.copyWith(comments: previousComments, isSubmitting: false);
      },
      (serverComment) {
        // SYNC: Replace the temporary comment with the one from the server
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
