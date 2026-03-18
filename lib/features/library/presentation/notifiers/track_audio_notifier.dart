import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/track_audio_state.dart';

class TrackAudioNotifier extends Notifier<TrackAudioState> {
  late final PlayerController playerController;

  StreamSubscription<int>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<void>? _completionSubscription;

  bool _isPrepared = false;
  bool _isDisposed = false;
  bool _isStopping = false;
  String? _preparedTrackUrl;

  @override
  TrackAudioState build() {
    playerController = PlayerController();

    _listenToPlayer();

    ref.onDispose(() async {
      _isDisposed = true;

      await _positionSubscription?.cancel();
      await _playerStateSubscription?.cancel();
      await _completionSubscription?.cancel();

      try {
        playerController.dispose();
      } catch (_) {}
    });

    return const TrackAudioState(
      isPlaying: false,
      position: Duration.zero,
      duration: Duration.zero,
      isDragging: false,
      progress: 0,
    );
  }

  void _listenToPlayer() {
    _positionSubscription = playerController.onCurrentDurationChanged.listen((
      currentMs,
    ) {
      if (_isDisposed || _isStopping || state.isDragging) {
        return;
      }

      final newPosition = Duration(milliseconds: currentMs);

      state = state.copyWith(
        position: newPosition,
        progress: _calculateProgress(
          position: newPosition,
          duration: state.duration,
        ),
      );
    }, onError: (_) {});

    _playerStateSubscription = playerController.onPlayerStateChanged.listen((
      playerState,
    ) {
      if (_isDisposed || _isStopping) {
        return;
      }

      state = state.copyWith(isPlaying: playerState == PlayerState.playing);
    }, onError: (_) {});

    _completionSubscription = playerController.onCompletion.listen((_) async {
      Future.delayed(const Duration(milliseconds: 200), () async {
        if (_isAtTrackEnd()) {
          await replay();
        } else {
          state = state.copyWith(
            isPlaying: false,
            position: state.duration,
            progress: 1,
          );
        }
      });
      if (_isDisposed || _isStopping) {
        return;
      }

      state = state.copyWith(
        isPlaying: false,
        position: state.duration,
        progress: 1,
        isDragging: false,
      );
    }, onError: (_) {});
  }

  Future<void> prepare({
    required String trackUrl,
    required Duration duration,
  }) async {
    if (_isDisposed) return;

    if (_isDisposed) return;

    state = state.copyWith(
      duration: duration,
      progress: _calculateProgress(
        position: state.position,
        duration: duration,
      ),
    );

    await playerController.preparePlayer(
      path: trackUrl,
      shouldExtractWaveform: false,
    );

    if (_isDisposed) return;

    _isPrepared = true;
    _preparedTrackUrl = trackUrl;

    try {
      final maxDurationMs = await playerController.getDuration(
        DurationType.max,
      );

      if (_isDisposed) return;

      if (maxDurationMs > 0) {
        final detectedDuration = Duration(milliseconds: maxDurationMs);
        state = state.copyWith(
          duration: detectedDuration,
          progress: _calculateProgress(
            position: state.position,
            duration: detectedDuration,
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> play() async {
    if (!_isPrepared || _isDisposed || _isStopping) return;

    await playerController.startPlayer();
  }

  Future<void> pause() async {
    if (!_isPrepared || _isDisposed) return;

    try {
      await playerController.pausePlayer();
    } catch (_) {}

    if (_isDisposed) return;

    state = state.copyWith(isPlaying: false);
  }

  Future<void> stop({bool resetState = true}) async {
    if (_isDisposed) return;

    _isStopping = true;

    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _completionSubscription?.cancel();

    _positionSubscription = null;
    _playerStateSubscription = null;
    _completionSubscription = null;

    try {
      if (_isPrepared) {
        await playerController.stopPlayer();
      }
    } catch (_) {}

    _isPrepared = false;
    _preparedTrackUrl = null;

    if (!_isDisposed && resetState) {
      state = state.copyWith(
        isPlaying: false,
        position: Duration.zero,
        duration: Duration.zero,
        progress: 0,
        isDragging: false,
      );
    }

    _isStopping = false;
  }

  void onDragUpdate(double progress) {
    if (_isDisposed) return;

    final clamped = progress.clamp(0.0, 1.0);

    final draggedPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clamped).round(),
    );

    state = state.copyWith(progress: clamped, position: draggedPosition);
  }

  Future<void> onDragEnd(double progress) async {
    if (_isDisposed) return;

    final clamped = progress.clamp(0.0, 1.0);

    final newPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clamped).round(),
    );

    state = state.copyWith(
      isDragging: false,
      position: newPosition,
      progress: clamped,
    );

    await seek(newPosition);
  }

  Future<void> seek(Duration position) async {
    if (!_isPrepared || _isDisposed) return;

    final safePosition = position > state.duration ? state.duration : position;

    try {
      await playerController.seekTo(safePosition.inMilliseconds);
    } catch (_) {}

    if (_isDisposed) return;

    state = state.copyWith(
      position: safePosition,
      progress: _calculateProgress(
        position: safePosition,
        duration: state.duration,
      ),
    );
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

  bool _isAtTrackEnd() {
    if (state.duration == Duration.zero) {
      return false;
    }

    return state.position.inMilliseconds >=
        (state.duration.inMilliseconds - 250);
  }

  Future<void> replay() async {
    if (_isDisposed || !_isPrepared || _preparedTrackUrl == null) return;

    try {
      await playerController.stopPlayer();

      state = state.copyWith(
        isPlaying: false,
        position: Duration.zero,
        progress: 0,
      );

      await playerController.preparePlayer(
        path: _preparedTrackUrl!,
        shouldExtractWaveform: false,
      );

      await playerController.startPlayer();

      state = state.copyWith(isPlaying: true);
    } catch (e) {}
  }
}
