import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_audio_state.freezed.dart';

@freezed
class TrackAudioState with _$TrackAudioState {
  const factory TrackAudioState({
    @Default(false) bool isPreparing,
    @Default(false) bool isPrepared,
    int? preparedTrackId,
    String? preparedTrackUrl,
    @Default(false) bool isPlaying,
    @Default(false) bool isDragging,
    double? dragProgress,
    Duration? dragPosition,
    @Default(0.0) double progress,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,
  }) = _TrackAudioState;
}
