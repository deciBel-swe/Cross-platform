import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../library/domain/entities/track.dart';

part 'track_audio_state.freezed.dart';

@freezed
class TrackAudioState with _$TrackAudioState {
  const factory TrackAudioState({
    @Default(false) bool isPreparing,
    @Default(false) bool isPrepared,
    int? preparedTrackId,
    String? preparedTrackUrl,

    /// The full track entity for the currently prepared track.
    /// Populated by [TrackAudioNotifier.initializeForTrack] so that any
    /// widget (desktop bar, mobile mini-player, etc.) can access cover art,
    /// display name, like status, etc. without a separate lookup.
    Track? currentTrack,

    /// Playback queue used for skip next/previous (based on where playback started).
    @Default(<Track>[]) List<Track> queue,
    @Default(false) bool isPlaying,
    @Default(false) bool isDragging,
    double? dragProgress,
    Duration? dragPosition,
    @Default(0.0) double progress,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,
  }) = _TrackAudioState;
}
