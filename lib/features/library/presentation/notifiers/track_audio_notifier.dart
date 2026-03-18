import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/track_audio_state.dart';

class TrackAudioNotifier extends Notifier<TrackAudioState> {
  Timer? _positionTimer;

  @override
  TrackAudioState build() {
    ref.onDispose(() {
      _positionTimer?.cancel();
    });

    return const TrackAudioState(
      isPlaying: false,
      position: Duration.zero,
      duration: Duration.zero,
      isDragging: false,
      progress: 0,
    );
  }

  void setDuration(Duration duration) {
    state = state.copyWith(
      duration: duration,
      progress: _calculateProgress(
        position: state.position,
        duration: duration,
      ),
    );
  }

  Future<void> play() async {
    state = state.copyWith(isPlaying: true);
    _startPositionUpdates();
  }

  Future<void> pause() async {
    state = state.copyWith(isPlaying: false);
    _positionTimer?.cancel();
  }

  void onDragStart() {
    state = state.copyWith(isDragging: true);
  }

  void onDragUpdate(double progress) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final newPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clampedProgress).round(),
    );

    state = state.copyWith(progress: clampedProgress, position: newPosition);
  }

  Future<void> onDragEnd(double progress) async {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final newPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clampedProgress).round(),
    );

    state = state.copyWith(
      isDragging: false,
      progress: clampedProgress,
      position: newPosition,
    );

    await seek(newPosition);
  }

  Future<void> seek(Duration position) async {
    final safePosition = position > state.duration ? state.duration : position;

    state = state.copyWith(
      position: safePosition,
      progress: _calculateProgress(
        position: safePosition,
        duration: state.duration,
      ),
    );
  }

  void _startPositionUpdates() {
    _positionTimer?.cancel();

    _positionTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (!state.isPlaying || state.isDragging) {
        return;
      }

      final nextPosition = state.position + const Duration(milliseconds: 250);

      if (nextPosition >= state.duration) {
        state = state.copyWith(
          isPlaying: false,
          position: state.duration,
          progress: 1,
        );
        timer.cancel();
        return;
      }

      state = state.copyWith(
        position: nextPosition,
        progress: _calculateProgress(
          position: nextPosition,
          duration: state.duration,
        ),
      );
    });
  }

  double _calculateProgress({
    required Duration position,
    required Duration duration,
  }) {
    if (duration.inMilliseconds == 0) {
      return 0;
    }

    return position.inMilliseconds / duration.inMilliseconds;
  }
}
