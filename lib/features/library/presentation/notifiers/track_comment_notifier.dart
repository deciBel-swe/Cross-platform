import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
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

    final optimisticComment = Comment(
      commentid: tempId,
      timestampSeconds: selectedTimestamp,
      body: body.trim(),
      createdAt: DateTime.now(),
      user: CommentUser(
        id: authUser.id,
        username: authUser.username,
        avatarUrl: authUser.avatarUrl!.isEmpty ? authUser.avatarUrl : '',
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
      commentid: tempId, // Pass tempId
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

final trackCommentsProvider =
    NotifierProvider.family<TrackCommentNotifier, TrackCommentsState, int>(
      TrackCommentNotifier.new,
    );
final currentActiveCommentsProvider = Provider.family<List<Comment>, int>((
  ref,
  trackId,
) {
  // 1. Get the current second from the audio player
  final audioState = ref.watch(trackAudioProvider);
  final currentSecond = (audioState.duration.inSeconds * audioState.progress)
      .round();

  // 2. Get all comments for this track
  final commentsState = ref.watch(trackCommentsProvider(trackId));

  // 3. Filter comments that match the exact current second
  final activeComments = commentsState.comments
      .where((c) => c.timestampSeconds == currentSecond)
      .toList();

  // 4. Sort them by creation time to ensure consistent ordering (oldest to newest)
  activeComments.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  return activeComments;
});
