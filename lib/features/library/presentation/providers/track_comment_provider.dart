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
  final currentSecond = (audioState.duration.inSeconds * audioState.progress)
      .round();

  ref.watch(trackCommentsProvider(trackId));
  return ref
      .read(trackCommentsProvider(trackId).notifier)
      .activeCommentsForSecond(currentSecond);
});

/// Derives the single comment currently shown over the preview waveform.
///
/// This keeps the "first active comment wins" rule out of the widget tree.
final currentActiveCommentProvider = Provider.family<Comment?, int>((
  ref,
  trackId,
) {
  final activeComments = ref.watch(currentActiveCommentsProvider(trackId));
  return activeComments.isEmpty ? null : activeComments.first;
});
