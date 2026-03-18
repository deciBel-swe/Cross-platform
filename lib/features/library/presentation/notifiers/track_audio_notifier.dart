import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/track_audio_state.dart';

class TrackAudioNotifier extends Notifier<TrackAudioState> {
  PlayerController? _playerController;

  StreamSubscription<int>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<void>? _completionSubscription;

  bool _isDisposed = false;
  bool _isStopping = false;

  PlayerController get playerController {
    final controller = _playerController;
    if (controller == null) {
      throw StateError('PlayerController is not initialized');
    }
    return controller;
  }

  @override
  TrackAudioState build() {
    _createPlayerController();
    _listenToPlayer();

    ref.onDispose(() async {
      _isDisposed = true;
      await _disposeCurrentPlayer();
    });

    return const TrackAudioState();
  }

  void _createPlayerController() {
    _playerController = PlayerController();
  }

  Future<void> _disposeCurrentPlayer() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _completionSubscription?.cancel();

    _positionSubscription = null;
    _playerStateSubscription = null;
    _completionSubscription = null;

    try {
      _playerController?.dispose();
    } catch (_) {}

    _playerController = null;
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
      if (_isDisposed || _isStopping || state.isDragging) {
        return;
      }

      await replay();
    }, onError: (_) {});
  }

  Future<void> initializeForTrack({
    required int trackId,
    required String trackUrl,
    Duration duration = Duration.zero,
    bool autoPlay = true,
  }) async {
    if (_isDisposed || _isStopping) return;
    if (state.isPreparing) return;

    final isSamePreparedTrack =
        state.isPrepared &&
        state.preparedTrackId == trackId &&
        state.preparedTrackUrl == trackUrl;

    if (isSamePreparedTrack) {
      if (autoPlay && !state.isPlaying) {
        await play();
      }
      return;
    }

    state = state.copyWith(isPreparing: true, duration: duration);

    try {
      await _prepareInternal(
        trackId: trackId,
        trackUrl: trackUrl,
        duration: duration,
      );

      if (autoPlay) {
        await play();
      }
    } finally {
      if (!_isDisposed) {
        state = state.copyWith(isPreparing: false);
      }
    }
  }

  Future<void> _prepareInternal({
    required int trackId,
    required String trackUrl,
    required Duration duration,
  }) async {
    if (_isDisposed) return;

    if (state.isPrepared) {
      try {
        await playerController.stopPlayer();
      } catch (_) {}
    }

    state = state.copyWith(
      isPlaying: false,
      isPrepared: false,
      preparedTrackId: null,
      preparedTrackUrl: null,
      position: Duration.zero,
      progress: 0,
      duration: duration,
      isDragging: false,
    );

    await playerController.preparePlayer(
      path: trackUrl,
      shouldExtractWaveform: false,
    );

    if (_isDisposed) return;

    var resolvedDuration = duration;

    try {
      final maxDurationMs = await playerController.getDuration(
        DurationType.max,
      );

      if (!_isDisposed && maxDurationMs > 0) {
        resolvedDuration = Duration(milliseconds: maxDurationMs);
      }
    } catch (_) {}

    if (_isDisposed) return;

    state = state.copyWith(
      isPrepared: true,
      preparedTrackId: trackId,
      preparedTrackUrl: trackUrl,
      duration: resolvedDuration,
      position: Duration.zero,
      progress: 0,
    );
  }

  Future<void> play() async {
    if (!state.isPrepared || _isDisposed || _isStopping) return;

    try {
      await playerController.startPlayer();
    } catch (_) {}
  }

  Future<void> pause() async {
    if (!state.isPrepared || _isDisposed || _isStopping) return;

    try {
      await playerController.pausePlayer();
    } catch (_) {}

    if (_isDisposed) return;

    state = state.copyWith(isPlaying: false);
  }

  Future<void> stop({bool resetState = true}) async {
    if (_isDisposed) return;

    _isStopping = true;

    try {
      if (state.isPrepared) {
        await playerController.stopPlayer();
      }
    } catch (_) {}

    if (!_isDisposed && resetState) {
      state = state.copyWith(
        isPreparing: false,
        isPrepared: false,
        preparedTrackId: null,
        preparedTrackUrl: null,
        isPlaying: false,
        position: Duration.zero,
        duration: Duration.zero,
        progress: 0,
        isDragging: false,
      );
    }

    _isStopping = false;
  }

  void onDragStart() {
    if (_isDisposed) return;

    state = state.copyWith(isDragging: true);
  }

  void onDragUpdate(double progress) {
    if (_isDisposed) return;

    final clamped = progress.clamp(0.0, 1.0);

    final draggedPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clamped).round(),
    );

    state = state.copyWith(
      isDragging: true,
      progress: clamped,
      position: draggedPosition,
    );
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
    if (!state.isPrepared || _isDisposed || _isStopping) return;

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

    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  Future<void> replay() async {
    if (_isDisposed || _isStopping) return;
    if (!state.isPrepared) return;
    if (state.preparedTrackUrl == null || state.preparedTrackId == null) return;

    final preparedTrackUrl = state.preparedTrackUrl!;
    final preparedTrackId = state.preparedTrackId!;
    final currentDuration = state.duration;

    _isStopping = true;

    try {
      await _disposeCurrentPlayer();

      if (_isDisposed) return;

      _createPlayerController();
      _listenToPlayer();

      await playerController.preparePlayer(
        path: preparedTrackUrl,
        shouldExtractWaveform: false,
      );

      if (_isDisposed) return;

      state = state.copyWith(
        isPrepared: true,
        preparedTrackId: preparedTrackId,
        preparedTrackUrl: preparedTrackUrl,
        isPlaying: false,
        isDragging: false,
        position: Duration.zero,
        progress: 0,
        duration: currentDuration,
      );

      await playerController.startPlayer();

      if (_isDisposed) return;

      state = state.copyWith(isPlaying: true);
    } catch (_) {
      if (!_isDisposed) {
        state = state.copyWith(isPlaying: false);
      }
    } finally {
      _isStopping = false;
    }
  }
}
