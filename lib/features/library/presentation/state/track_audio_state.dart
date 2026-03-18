import 'package:freezed_annotation/freezed_annotation.dart';
part 'track_audio_state.freezed.dart';

@freezed
class TrackAudioState with _$TrackAudioState {
  const factory TrackAudioState({
    required bool isPlaying,
    required Duration position,
    required Duration duration,
    required bool isDragging,
    required double progress,
  }) = _TrackAudioState;
}
