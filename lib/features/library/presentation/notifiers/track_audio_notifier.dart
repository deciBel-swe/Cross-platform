import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../home/presentation/providers/history_provider.dart';
import '../../domain/entities/track.dart';
import '../state/track_audio_state.dart';

class TrackAudioNotifier extends Notifier<TrackAudioState> {
  AudioPlayer? _player;

  /// Factory for creating AudioPlayer instances, customizable for testing.
  @visibleForTesting
  static AudioPlayer Function()? audioPlayerFactory;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;

  bool _isDisposed = false;
  bool _isStopping = false;
  int _operationGeneration = 0;
  Future<void> _transitionQueue = Future<void>.value();
  bool _hasReportedPlayForPreparedTrack = false;
  int? _reportedPlayTrackId;

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
      _operationGeneration += 1;
      _isDisposed = true;
      await _disposeCurrentPlayer();
    });

    return const TrackAudioState();
  }

  void _createPlayer() {
    _player = audioPlayerFactory?.call() ?? AudioPlayer();
  }

  Future<void> _disposeCurrentPlayer() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _playbackEventSubscription?.cancel();

    _positionSubscription = null;
    _playerStateSubscription = null;
    _durationSubscription = null;
    _playbackEventSubscription = null;

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

      debugPrint(
        '[AudioStream] State: ${event.playing ? "Playing" : "Paused"} | Processing: ${event.processingState}',
      );

      state = state.copyWith(isPlaying: event.playing);

      if (event.processingState == ProcessingState.completed &&
          !state.isDragging) {
        _reportTrackCompleted();
        unawaited(replay());
      }
    }, onError: (_) {});

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (_isDisposed || _isStopping || duration == null) {
        return;
      }

      if (duration != state.duration) {
        state = state.copyWith(
          duration: duration,
          progress: _calculateProgress(
            position: state.position,
            duration: duration,
          ),
        );
      }
    }, onError: (_) {});

    _playbackEventSubscription = _audioPlayer.playbackEventStream.listen((
      event,
    ) {
      if (_isDisposed) return;
      debugPrint(
        '[AudioStream] Buffer Status | Buffered: ${event.bufferedPosition} | Total: ${state.duration}',
      );
    }, onError: (_) {});
  }

  Future<void> _runSerializedTransition(
    Future<void> Function(int operationId) transition,
  ) {
    final operationId = ++_operationGeneration;
    final nextTransition = _transitionQueue.then((_) async {
      if (_isDisposed) {
        return;
      }
      await transition(operationId);
    });

    _transitionQueue = nextTransition.catchError((_) {});
    return nextTransition;
  }

  Future<void> initializeForTrack({
    required int trackId,
    required String trackUrl,
    Track? track,
    List<Track>? queue,
    Duration duration = Duration.zero,
    bool autoPlay = true,
  }) async {
    if (_isDisposed || _isStopping) return;

    final sanitizedQueue = _sanitizeQueue(
      queue ?? state.queue,
      currentTrack: track,
    );

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

    await _runSerializedTransition((operationId) async {
      if (_isDisposed) {
        return;
      }

      state = state.copyWith(
        isPreparing: true,
        duration: duration,
        queue: sanitizedQueue,
      );

      try {
        debugPrint(
          '[AudioStream] Initializing source: $trackUrl (Network Streaming Active)',
        );

        await _prepareInternal(
          trackId: trackId,
          trackUrl: trackUrl,
          track: track,
          duration: duration,
          operationId: operationId,
        );

        if (_isDisposed || operationId != _operationGeneration) {
          return;
        }

        if (track != null) {
          ref.read(historyProvider.notifier).addLocalRecentlyPlayed(track);
        }

        if (autoPlay) {
          await play();
        }
      } catch (error) {
        // Guard against source-load failures (e.g. invalid/unreachable URL)
        // so playback errors don't bubble as unhandled UI exceptions.
        if (kDebugMode) {
          debugPrint('TrackAudioNotifier initializeForTrack failed: $error');
        }

        if (!_isDisposed && operationId == _operationGeneration) {
          state = state.copyWith(
            isPrepared: false,
            preparedTrackId: null,
            preparedTrackUrl: null,
            currentTrack: null,
            isPlaying: false,
            position: Duration.zero,
            progress: 0,
            dragProgress: null,
            dragPosition: null,
            isDragging: false,
          );
        }
      } finally {
        if (!_isDisposed && operationId == _operationGeneration) {
          state = state.copyWith(isPreparing: false);
        }
      }
    });
  }

  Future<void> _prepareInternal({
    required int trackId,
    required String trackUrl,
    Track? track,
    required Duration duration,
    required int operationId,
  }) async {
    if (_isDisposed || operationId != _operationGeneration) return;

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
      currentTrack: null,
      position: Duration.zero,
      progress: 0,
      duration: duration,
      isDragging: false,
      dragProgress: null,
      dragPosition: null,
    );

    final loadedDuration = await _setSource(
      trackId: trackId,
      urlOrPath: trackUrl,
      track: track,
    );

    if (_isDisposed || operationId != _operationGeneration) return;

    var resolvedDuration = duration;

    if (loadedDuration != null && loadedDuration.inMilliseconds > 0) {
      resolvedDuration = loadedDuration;
    } else {
      final playerDuration = _audioPlayer.duration;
      if (playerDuration != null && playerDuration.inMilliseconds > 0) {
        resolvedDuration = playerDuration;
      }
    }

    if (_isDisposed || operationId != _operationGeneration) return;

    state = state.copyWith(
      isPrepared: true,
      preparedTrackId: trackId,
      preparedTrackUrl: trackUrl,
      currentTrack: track,
      duration: resolvedDuration,
      position: Duration.zero,
      progress: 0,
      dragProgress: null,
      dragPosition: null,
    );

    _hasReportedPlayForPreparedTrack = false;
    _reportedPlayTrackId = trackId;
  }

  Future<void> skipNext() async {
    if (_isDisposed || _isStopping) return;
    final currentId = state.preparedTrackId;
    if (currentId == null) return;

    final queue = state.queue;
    if (queue.isEmpty) return;

    final currentIndex = queue.indexWhere((t) => t.id == currentId);
    if (currentIndex == -1) return;

    final nextIndex = currentIndex + 1;
    if (nextIndex >= queue.length) return;

    final nextTrack = queue[nextIndex];
    await playTrack(track: nextTrack, queue: queue, autoPlay: true);
  }

  Future<void> skipPrevious() async {
    if (_isDisposed || _isStopping) return;
    final currentId = state.preparedTrackId;
    if (currentId == null) return;

    final queue = state.queue;
    if (queue.isEmpty) return;

    final currentIndex = queue.indexWhere((t) => t.id == currentId);
    if (currentIndex == -1) return;

    final previousIndex = currentIndex - 1;
    if (previousIndex < 0) return;

    final previousTrack = queue[previousIndex];
    await playTrack(track: previousTrack, queue: queue, autoPlay: true);
  }

  void addToQueue(Track track) {
    if (_isDisposed) return;
    if (!track.isPlayable) return;

    final nextQueue = List<Track>.from(state.queue);
    final alreadyInQueue = nextQueue.any((t) => t.id == track.id);
    if (alreadyInQueue) return;

    nextQueue.add(track);
    state = state.copyWith(queue: _sanitizeQueue(nextQueue));
  }

  void removeFromQueue(int trackId) {
    if (_isDisposed) return;

    final nextQueue = state.queue.where((t) => t.id != trackId).toList();
    if (nextQueue.length == state.queue.length) return;

    state = state.copyWith(queue: nextQueue);
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (_isDisposed) return;
    if (oldIndex < 0 || oldIndex >= state.queue.length) return;

    final nextQueue = List<Track>.from(state.queue);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (newIndex < 0 || newIndex >= nextQueue.length) return;

    final item = nextQueue.removeAt(oldIndex);
    nextQueue.insert(newIndex, item);

    state = state.copyWith(queue: nextQueue);
  }

  Future<void> playFromQueueIndex(int index) async {
    if (_isDisposed || _isStopping) return;
    final queue = state.queue;
    if (index < 0 || index >= queue.length) return;

    final selected = queue[index];
    await playTrack(track: selected, queue: queue, autoPlay: true);
  }

  Future<void> playTrack({
    required Track track,
    List<Track>? queue,
    Duration duration = Duration.zero,
    bool autoPlay = true,
  }) async {
    if (_isDisposed || _isStopping) return;

    final trackUrl = track.normalizedTrackUrl;
    if (!track.isPlayable || trackUrl == null) {
      return;
    }

    await initializeForTrack(
      trackId: track.id,
      trackUrl: trackUrl,
      track: track,
      queue: queue,
      duration: duration,
      autoPlay: autoPlay,
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
    _reportPlayStartedIfNeeded();
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
        currentTrack: null,
        isPlaying: false,
        position: Duration.zero,
        duration: Duration.zero,
        progress: 0,
        isDragging: false,
        dragProgress: null,
        dragPosition: null,
      );

      _hasReportedPlayForPreparedTrack = false;
      _reportedPlayTrackId = null;
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
    await _runSerializedTransition((operationId) async {
      if (_isDisposed || _isStopping || state.isPreparing) return;
      if (!state.isPrepared) return;
      if (state.preparedTrackUrl == null || state.preparedTrackId == null) {
        return;
      }

      _isStopping = true;
      var didRestart = false;

      final preparedTrackId = state.preparedTrackId!;
      final preparedUrl = state.preparedTrackUrl!;
      final currentTrack = state.currentTrack;

      try {
        await _audioPlayer.stop();
        if (_isDisposed || operationId != _operationGeneration) {
          return;
        }

        await _disposeCurrentPlayer();
        if (_isDisposed || operationId != _operationGeneration) {
          return;
        }

        _createPlayer();

        await _setSource(
          trackId: preparedTrackId,
          urlOrPath: preparedUrl,
          track: currentTrack,
        );
        if (_isDisposed || operationId != _operationGeneration) {
          return;
        }

        _listenToPlayer();
        await _audioPlayer.seek(Duration.zero);
        if (_isDisposed || operationId != _operationGeneration) {
          return;
        }

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
        if (!_isDisposed && operationId == _operationGeneration) {
          state = state.copyWith(isPlaying: false);
        }
      } finally {
        _isStopping = false;
      }

      if (_isDisposed || !didRestart || operationId != _operationGeneration) {
        return;
      }

      // Resume playback after recreating the player only for the latest operation.
      await play();
    });
  }

  Future<Duration?> _setSource({
    required int trackId,
    required String urlOrPath,
    Track? track,
  }) async {
    final normalizedSource = urlOrPath.trim();
    if (normalizedSource.isEmpty) {
      // Fail fast for invalid audio source values.
      throw const FormatException('Track source is empty');
    }

    final mediaItem = _buildMediaItem(
      trackId: trackId,
      urlOrPath: normalizedSource,
      track: track,
    );

    final uri = Uri.tryParse(normalizedSource);
    if (uri != null && uri.hasScheme) {
      debugPrint('[AudioStream] Source is Network URL. Using preload: false.');
      return _audioPlayer.setAudioSource(
        AudioSource.uri(uri, tag: mediaItem),
        preload: false,
      );
    }

    return _audioPlayer.setAudioSource(
      AudioSource.uri(Uri.file(normalizedSource), tag: mediaItem),
      preload: false,
    );
  }

  MediaItem _buildMediaItem({
    required int trackId,
    required String urlOrPath,
    Track? track,
  }) {
    final title = track?.title.trim();
    final artistName = track?.artist.displayName ?? track?.artist.username;
    final coverUrl = track?.coverUrl?.trim();

    return MediaItem(
      id: trackId.toString(),
      title: (title == null || title.isEmpty) ? 'Unknown track' : title,
      artist: (artistName == null || artistName.isEmpty)
          ? 'Unknown artist'
          : artistName,
      album: 'Decibel',
      artUri: (coverUrl != null && coverUrl.isNotEmpty)
          ? Uri.tryParse(coverUrl)
          : null,
      extras: <String, dynamic>{'source': urlOrPath},
    );
  }

  Future<void> setVolume(double volume) async {
    if (_isDisposed || _isStopping) return;
    try {
      await _audioPlayer.setVolume(volume);
    } catch (_) {}
  }

  void _reportPlayStartedIfNeeded() {
    final trackId = state.preparedTrackId;
    if (trackId == null) {
      return;
    }

    final alreadyReported =
        _hasReportedPlayForPreparedTrack && _reportedPlayTrackId == trackId;
    if (alreadyReported) {
      return;
    }

    _hasReportedPlayForPreparedTrack = true;
    _reportedPlayTrackId = trackId;
    unawaited(_recordTrackPlayStarted(trackId));
  }

  void _reportTrackCompleted() {
    final trackId = state.preparedTrackId;
    if (trackId == null) {
      return;
    }

    unawaited(_recordTrackCompleted(trackId));
  }

  Future<void> _recordTrackPlayStarted(int trackId) async {
    final repository = ref.read(historyRepositoryProvider);
    await repository.incrementPlayCount(trackId: trackId);
  }

  Future<void> _recordTrackCompleted(int trackId) async {
    final repository = ref.read(historyRepositoryProvider);
    await repository.markTrackCompleted(trackId: trackId);
  }

  List<Track> _sanitizeQueue(List<Track> queue, {Track? currentTrack}) {
    final sanitizedQueue = <Track>[];
    final seenTrackIds = <int>{};

    for (final track in queue) {
      if (!track.isPlayable || !seenTrackIds.add(track.id)) {
        continue;
      }
      sanitizedQueue.add(track);
    }

    if (currentTrack != null &&
        currentTrack.isPlayable &&
        seenTrackIds.add(currentTrack.id)) {
      sanitizedQueue.insert(0, currentTrack);
    }

    return sanitizedQueue;
  }
}
