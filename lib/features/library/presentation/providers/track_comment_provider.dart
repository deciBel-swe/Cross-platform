import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../domain/entities/comment.dart';
import '../notifiers/track_comment_notifier.dart';
import '../state/track_comment_state.dart';

/// Provider for the track comments notifier, keyed by trackId.
///
/// Each track gets its own isolated comment state. Widgets subscribe to
/// `trackCommentsProvider(trackId)` to both read state and call notifier
/// methods (`selectTimestamp`, `postComment`).
final trackCommentsProvider =
    NotifierProvider.family<TrackCommentNotifier, TrackCommentsState, int>(
      TrackCommentNotifier.new,
    );

/// Derives the list of comments that are active at the current playback second
/// for a given trackId.
///
/// Audio position is read from [trackAudioProvider] and compared against each
/// comment's [Comment.timestampSeconds]. Results are sorted oldest-first so
/// that the earliest comment in a second is always shown at the top.
final currentActiveCommentsProvider = Provider.family<List<Comment>, int>((
  ref,
  trackId,
) {
  final audioState = ref.watch(trackAudioProvider);
  final currentSecond =
      (audioState.duration.inSeconds * audioState.progress).round();

  final commentsState = ref.watch(trackCommentsProvider(trackId));

  final activeComments =
      commentsState.comments
          .where((c) => c.timestampSeconds == currentSecond)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  return activeComments;
});
