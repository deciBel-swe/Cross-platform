import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../state/track_audio_state.dart';

class TrackAudioNotifier extends Notifier<TrackAudioState> {
  AudioPlayer? _player;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool _isDisposed = false;
  bool _isStopping = false;

  AudioPlayer get _audioPlayer {
    final player = _player;
    if (player == null) {
      throw StateError('AudioPlayer is not initialized');
    }
    return player;
  }

  @override
  TrackAudioState build() {
    _createPlayer();
    _listenToPlayer();

    ref.onDispose(() async {
      _isDisposed = true;
      await _disposeCurrentPlayer();
    });

    return const TrackAudioState();
  }

  void _createPlayer() {
    _player = AudioPlayer();
  }

  Future<void> _disposeCurrentPlayer() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();

    _positionSubscription = null;
    _playerStateSubscription = null;

    try {
      await _player?.dispose();
    } catch (_) {}

    _player = null;
  }

  void _listenToPlayer() {
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (_isDisposed || _isStopping || state.isDragging) {
        return;
      }

      final newPosition = position;

      state = state.copyWith(
        position: newPosition,
        progress: _calculateProgress(
          position: newPosition,
          duration: state.duration,
        ),
      );
    }, onError: (_) {});

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((event) {
      if (_isDisposed || _isStopping) {
        return;
      }

      state = state.copyWith(isPlaying: event.playing);

      if (event.processingState == ProcessingState.completed &&
          !state.isDragging) {
        // Keep the existing behavior: auto-replay when playback completes.
        replay();
      }
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
        await _audioPlayer.stop();
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
      dragProgress: null,
      dragPosition: null,
    );

    final loadedDuration = await _setSource(trackUrl);

    if (_isDisposed) return;

    var resolvedDuration = duration;

    if (loadedDuration != null && loadedDuration.inMilliseconds > 0) {
      resolvedDuration = loadedDuration;
    } else {
      final playerDuration = _audioPlayer.duration;
      if (playerDuration != null && playerDuration.inMilliseconds > 0) {
        resolvedDuration = playerDuration;
      }
    }

    if (_isDisposed) return;

    state = state.copyWith(
      isPrepared: true,
      preparedTrackId: trackId,
      preparedTrackUrl: trackUrl,
      duration: resolvedDuration,
      position: Duration.zero,
      progress: 0,
      dragProgress: null,
      dragPosition: null,
    );
  }

  Future<void> play() async {
    if (!state.isPrepared || _isDisposed || _isStopping) return;

    try {
      unawaited(
        _audioPlayer.play().catchError((_) {
          if (!_isDisposed) {
            state = state.copyWith(isPlaying: false);
          }
        }),
      );
    } catch (_) {
      if (!_isDisposed) {
        state = state.copyWith(isPlaying: false);
      }
      return;
    }

    if (_isDisposed || _isStopping) return;

    state = state.copyWith(isPlaying: true);
  }

  Future<void> pause() async {
    if (!state.isPrepared || _isDisposed || _isStopping) return;

    try {
      await _audioPlayer.pause();
    } catch (_) {}

    if (_isDisposed) return;

    state = state.copyWith(isPlaying: false);
  }

  Future<void> stop({bool resetState = true}) async {
    if (_isDisposed) return;

    _isStopping = true;

    try {
      if (state.isPrepared) {
        await _audioPlayer.stop();
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
        dragProgress: null,
        dragPosition: null,
      );
    }

    _isStopping = false;
  }

  void onDragStart() {
    if (_isDisposed) return;

    state = state.copyWith(
      isDragging: true,
      dragProgress: state.progress,
      dragPosition: state.position,
    );
  }

  void onDragUpdate(double progress) {
    if (_isDisposed) return;

    final clamped = progress.clamp(0.0, 1.0);

    final draggedPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clamped).round(),
    );

    state = state.copyWith(
      isDragging: true,
      dragProgress: clamped,
      dragPosition: draggedPosition,
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
      dragProgress: null,
      dragPosition: null,
    );

    await seek(newPosition);
  }

  Future<void> seek(Duration position) async {
    if (!state.isPrepared || _isDisposed || _isStopping) return;

    final safePosition = position > state.duration ? state.duration : position;

    try {
      await _audioPlayer.seek(safePosition);
    } catch (_) {}

    if (_isDisposed) return;

    state = state.copyWith(
      position: safePosition,
      progress: _calculateProgress(
        position: safePosition,
        duration: state.duration,
      ),
      dragProgress: null,
      dragPosition: null,
      isDragging: false,
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

    _isStopping = true;

    var didRestart = false;

    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await _audioPlayer.stop();

      await _disposeCurrentPlayer();
      final preparedurl = state.preparedTrackUrl!;
      if (_isDisposed) return;
      _createPlayer();

      await _setSource(preparedurl);
      _listenToPlayer();
      await _audioPlayer.seek(Duration.zero);
      if (_isDisposed) return;

      state = state.copyWith(
        isPlaying: false,
        isDragging: false,
        dragProgress: null,
        dragPosition: null,
        position: Duration.zero,
        progress: 0,
      );

      didRestart = true;
    } catch (_) {
      if (!_isDisposed) {
        state = state.copyWith(isPlaying: false);
      }
    } finally {
      _isStopping = false;
    }

    if (_isDisposed || !didRestart) return;

    // Actually resume playback after recreating the player.
    await play();
  }

  Future<Duration?> _setSource(String urlOrPath) async {
    final uri = Uri.tryParse(urlOrPath);
    if (uri != null && uri.hasScheme) {
      return _audioPlayer.setUrl(urlOrPath);
    }
    return _audioPlayer.setFilePath(urlOrPath);
  }
}
