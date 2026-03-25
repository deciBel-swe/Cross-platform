import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    if (body.trim().isEmpty || selectedTimestamp == null) {
      return;
    }

    state = state.copyWith(isSubmitting: true);

    final result = await _repository.postComment(
      trackId: _trackId,
      body: body.trim(),
      timestampSeconds: selectedTimestamp,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isSubmitting: false);
      },
      (comment) {
        state = state.copyWith(
          comments: [comment, ...state.comments],
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
