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
  double _playerVolume = 1;

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
      debugPrint('[TrackAudioNotifier] ERROR: AudioPlayer is null');
      throw StateError('AudioPlayer is not initialized');
    }
    return player;
  }

  @override
  TrackAudioState build() {
    debugPrint('==============================');
    debugPrint('[TrackAudioNotifier] build() called');

    _createPlayer();
    _listenToPlayer();

    ref.onDispose(() async {
      debugPrint('[TrackAudioNotifier] ref.onDispose() called');

      _operationGeneration += 1;
      _isDisposed = true;

      debugPrint(
        '[TrackAudioNotifier] disposing current player | generation=$_operationGeneration',
      );

      await _disposeCurrentPlayer();

      debugPrint('[TrackAudioNotifier] dispose finished');
    });

    debugPrint('[TrackAudioNotifier] initial state returned');
    return const TrackAudioState();
  }

  void _createPlayer() {
    debugPrint('[TrackAudioNotifier] _createPlayer() called');

    _player = audioPlayerFactory?.call() ?? AudioPlayer();
    _player?.setVolume(_playerVolume);

    debugPrint('[TrackAudioNotifier] AudioPlayer created: ${_player != null}');
  }

  Future<void> _disposeCurrentPlayer() async {
    debugPrint('[TrackAudioNotifier] _disposeCurrentPlayer() called');

    await _positionSubscription?.cancel();
    debugPrint('[TrackAudioNotifier] position subscription cancelled');

    await _playerStateSubscription?.cancel();
    debugPrint('[TrackAudioNotifier] player state subscription cancelled');

    await _durationSubscription?.cancel();
    debugPrint('[TrackAudioNotifier] duration subscription cancelled');

    await _playbackEventSubscription?.cancel();
    debugPrint('[TrackAudioNotifier] playback event subscription cancelled');

    _positionSubscription = null;
    _playerStateSubscription = null;
    _durationSubscription = null;
    _playbackEventSubscription = null;

    try {
      debugPrint('[TrackAudioNotifier] disposing AudioPlayer');
      await _player?.dispose();
      debugPrint('[TrackAudioNotifier] AudioPlayer disposed successfully');
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] AudioPlayer dispose failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
    }

    _player = null;
  }

  void _listenToPlayer() {
    debugPrint('[TrackAudioNotifier] _listenToPlayer() called');

    _positionSubscription = _audioPlayer.positionStream.listen(
      (position) {
        if (_isDisposed) {
          debugPrint(
            '[AudioStream:position] ignored because notifier is disposed',
          );
          return;
        }

        if (_isStopping) {
          debugPrint(
            '[AudioStream:position] ignored because player is stopping',
          );
          return;
        }

        if (state.isDragging) {
          debugPrint('[AudioStream:position] ignored because user is dragging');
          return;
        }

        state = state.copyWith(
          position: position,
          progress: _calculateProgress(
            position: position,
            duration: state.duration,
          ),
        );

        debugPrint(
          '[AudioStream:position] position=$position | duration=${state.duration} | progress=${state.progress}',
        );
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[AudioStream:position] ERROR: $error');
        debugPrint('[AudioStream:position] stackTrace: $stackTrace');
      },
      onDone: () {
        debugPrint('[AudioStream:position] DONE');
      },
    );

    debugPrint('[TrackAudioNotifier] positionStream listener attached');

    _playerStateSubscription = _audioPlayer.playerStateStream.listen(
      (event) {
        if (_isDisposed) {
          debugPrint(
            '[AudioStream:state] ignored because notifier is disposed',
          );
          return;
        }

        if (_isStopping) {
          debugPrint('[AudioStream:state] ignored because player is stopping');
          return;
        }

        debugPrint(
          '[AudioStream:state] playing=${event.playing} | processing=${event.processingState}',
        );

        state = state.copyWith(isPlaying: event.playing);

        if (event.processingState == ProcessingState.completed &&
            !state.isDragging) {
          debugPrint('[AudioStream:state] track completed');
          _reportTrackCompleted();

          debugPrint('[AudioStream:state] calling replay() after completion');
          unawaited(replay());
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[AudioStream:state] ERROR: $error');
        debugPrint('[AudioStream:state] stackTrace: $stackTrace');
      },
      onDone: () {
        debugPrint('[AudioStream:state] DONE');
      },
    );

    debugPrint('[TrackAudioNotifier] playerStateStream listener attached');

    _durationSubscription = _audioPlayer.durationStream.listen(
      (duration) {
        if (_isDisposed) {
          debugPrint(
            '[AudioStream:duration] ignored because notifier is disposed',
          );
          return;
        }

        if (_isStopping) {
          debugPrint(
            '[AudioStream:duration] ignored because player is stopping',
          );
          return;
        }

        if (duration == null) {
          debugPrint('[AudioStream:duration] ignored because duration is null');
          return;
        }

        debugPrint('[AudioStream:duration] duration emitted: $duration');

        if (duration != state.duration) {
          state = state.copyWith(
            duration: duration,
            progress: _calculateProgress(
              position: state.position,
              duration: duration,
            ),
          );

          debugPrint(
            '[AudioStream:duration] state duration updated | progress=${state.progress}',
          );
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[AudioStream:duration] ERROR: $error');
        debugPrint('[AudioStream:duration] stackTrace: $stackTrace');
      },
      onDone: () {
        debugPrint('[AudioStream:duration] DONE');
      },
    );

    debugPrint('[TrackAudioNotifier] durationStream listener attached');

    _playbackEventSubscription = _audioPlayer.playbackEventStream.listen(
      (event) {
        if (_isDisposed) {
          debugPrint(
            '[AudioStream:event] ignored because notifier is disposed',
          );
          return;
        }

        debugPrint(
          '[AudioStream:event] buffered=${event.bufferedPosition} | updatePosition=${event.updatePosition} | duration=${state.duration} | processing=${event.processingState}',
        );
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[AudioStream:event] ERROR: $error');
        debugPrint('[AudioStream:event] stackTrace: $stackTrace');
      },
      onDone: () {
        debugPrint('[AudioStream:event] DONE');
      },
    );

    debugPrint('[TrackAudioNotifier] playbackEventStream listener attached');
  }

  Future<void> _runSerializedTransition(
    Future<void> Function(int operationId) transition,
  ) {
    final operationId = ++_operationGeneration;

    debugPrint('------------------------------');
    debugPrint(
      '[TrackAudioNotifier] _runSerializedTransition() queued | operationId=$operationId',
    );

    final nextTransition = _transitionQueue.then((_) async {
      debugPrint(
        '[TrackAudioNotifier] transition started | operationId=$operationId | currentGeneration=$_operationGeneration',
      );

      if (_isDisposed) {
        debugPrint(
          '[TrackAudioNotifier] transition cancelled because notifier is disposed',
        );
        return;
      }

      await transition(operationId);

      debugPrint(
        '[TrackAudioNotifier] transition finished | operationId=$operationId',
      );
    });

    _transitionQueue = nextTransition.catchError((Object error, StackTrace st) {
      debugPrint('[TrackAudioNotifier] transition error swallowed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $st');
    });

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
    debugPrint('==============================');
    debugPrint('[TrackAudioNotifier] initializeForTrack() called');
    debugPrint('[TrackAudioNotifier] trackId=$trackId');
    debugPrint('[TrackAudioNotifier] trackUrl=$trackUrl');
    debugPrint('[TrackAudioNotifier] trackTitle=${track?.title}');
    debugPrint('[TrackAudioNotifier] duration=$duration');
    debugPrint('[TrackAudioNotifier] autoPlay=$autoPlay');
    debugPrint('[TrackAudioNotifier] isDisposed=$_isDisposed');
    debugPrint('[TrackAudioNotifier] isStopping=$_isStopping');

    if (_isDisposed || _isStopping) {
      debugPrint(
        '[TrackAudioNotifier] initializeForTrack() stopped early because disposed/stopping',
      );
      return;
    }

    final sanitizedQueue = _sanitizeQueue(
      queue ?? state.queue,
      currentTrack: track,
    );

    debugPrint(
      '[TrackAudioNotifier] sanitizedQueue length=${sanitizedQueue.length}',
    );

    final isSamePreparedTrack =
        state.isPrepared &&
        state.preparedTrackId == trackId &&
        state.preparedTrackUrl == trackUrl;

    debugPrint('[TrackAudioNotifier] isSamePreparedTrack=$isSamePreparedTrack');

    if (isSamePreparedTrack) {
      debugPrint('[TrackAudioNotifier] same prepared track detected');

      if (autoPlay && !state.isPlaying) {
        debugPrint(
          '[TrackAudioNotifier] autoPlay=true and not playing, calling play()',
        );
        await play();
      }

      return;
    }

    await _runSerializedTransition((operationId) async {
      if (_isDisposed) {
        debugPrint(
          '[TrackAudioNotifier] initialize transition cancelled because disposed',
        );
        return;
      }

      debugPrint(
        '[TrackAudioNotifier] preparing track | operationId=$operationId',
      );

      state = state.copyWith(
        isPreparing: true,
        duration: duration,
        queue: sanitizedQueue,
      );

      try {
        debugPrint(
          '[TrackAudioNotifier] calling _prepareInternal() for URL: $trackUrl',
        );

        await _prepareInternal(
          trackId: trackId,
          trackUrl: trackUrl,
          track: track,
          duration: duration,
          operationId: operationId,
        );

        if (_isDisposed || operationId != _operationGeneration) {
          debugPrint(
            '[TrackAudioNotifier] after prepare ignored | disposed=$_isDisposed | operationId=$operationId | generation=$_operationGeneration',
          );
          return;
        }

        if (track != null) {
          debugPrint('[TrackAudioNotifier] adding local recently played');
          ref.read(historyProvider.notifier).addLocalRecentlyPlayed(track);
        }

        if (autoPlay) {
          debugPrint('[TrackAudioNotifier] autoPlay=true, calling play()');
          await play();
        } else {
          debugPrint('[TrackAudioNotifier] autoPlay=false, prepared only');
        }
      } catch (error, stackTrace) {
        debugPrint('[TrackAudioNotifier] initializeForTrack failed: $error');
        debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');

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

          debugPrint(
            '[TrackAudioNotifier] state reset after initialize failure',
          );
        }
      } finally {
        if (!_isDisposed && operationId == _operationGeneration) {
          state = state.copyWith(isPreparing: false);
          debugPrint('[TrackAudioNotifier] isPreparing=false');
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
    debugPrint('[TrackAudioNotifier] _prepareInternal() called');
    debugPrint('[TrackAudioNotifier] operationId=$operationId');
    debugPrint('[TrackAudioNotifier] trackId=$trackId');
    debugPrint('[TrackAudioNotifier] trackUrl=$trackUrl');
    debugPrint('[TrackAudioNotifier] currentlyPrepared=${state.isPrepared}');

    if (_isDisposed || operationId != _operationGeneration) {
      debugPrint('[TrackAudioNotifier] _prepareInternal cancelled early');
      return;
    }

    if (state.isPrepared) {
      try {
        debugPrint('[TrackAudioNotifier] stopping existing prepared player');
        await _audioPlayer.stop();
        debugPrint('[TrackAudioNotifier] existing player stopped');
      } catch (error, stackTrace) {
        debugPrint('[TrackAudioNotifier] stop existing player failed: $error');
        debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
      }
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

    debugPrint('[TrackAudioNotifier] state reset before setting source');

    final loadedDuration = await _setSource(
      trackId: trackId,
      urlOrPath: trackUrl,
      track: track,
    );

    debugPrint(
      '[TrackAudioNotifier] _setSource returned duration=$loadedDuration',
    );

    if (_isDisposed || operationId != _operationGeneration) {
      debugPrint('[TrackAudioNotifier] after _setSource ignored');
      return;
    }

    var resolvedDuration = duration;

    if (loadedDuration != null && loadedDuration.inMilliseconds > 0) {
      resolvedDuration = loadedDuration;
      debugPrint('[TrackAudioNotifier] using loadedDuration=$resolvedDuration');
    } else {
      final playerDuration = _audioPlayer.duration;
      debugPrint('[TrackAudioNotifier] playerDuration=$playerDuration');

      if (playerDuration != null && playerDuration.inMilliseconds > 0) {
        resolvedDuration = playerDuration;
        debugPrint(
          '[TrackAudioNotifier] using playerDuration=$resolvedDuration',
        );
      } else {
        debugPrint(
          '[TrackAudioNotifier] keeping input duration=$resolvedDuration',
        );
      }
    }

    if (_isDisposed || operationId != _operationGeneration) {
      debugPrint('[TrackAudioNotifier] before prepared state ignored');
      return;
    }

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

    debugPrint('[TrackAudioNotifier] track prepared successfully');
    debugPrint('[TrackAudioNotifier] preparedTrackId=${state.preparedTrackId}');
    debugPrint(
      '[TrackAudioNotifier] preparedTrackUrl=${state.preparedTrackUrl}',
    );
    debugPrint('[TrackAudioNotifier] resolvedDuration=${state.duration}');

    _hasReportedPlayForPreparedTrack = false;
    _reportedPlayTrackId = trackId;

    debugPrint('[TrackAudioNotifier] play reporting reset');
  }

  Future<void> skipNext() async {
    debugPrint('[TrackAudioNotifier] skipNext() called');

    if (_isDisposed || _isStopping) {
      debugPrint(
        '[TrackAudioNotifier] skipNext ignored because disposed/stopping',
      );
      return;
    }

    final currentId = state.preparedTrackId;
    debugPrint('[TrackAudioNotifier] currentId=$currentId');

    if (currentId == null) return;

    final queue = state.queue;
    debugPrint('[TrackAudioNotifier] queue length=${queue.length}');

    if (queue.isEmpty) return;

    final currentIndex = queue.indexWhere((t) => t.id == currentId);
    debugPrint('[TrackAudioNotifier] currentIndex=$currentIndex');

    if (currentIndex == -1) return;

    final nextIndex = currentIndex + 1;
    debugPrint('[TrackAudioNotifier] nextIndex=$nextIndex');

    if (nextIndex >= queue.length) {
      debugPrint('[TrackAudioNotifier] no next track');
      return;
    }

    final nextTrack = queue[nextIndex];
    debugPrint('[TrackAudioNotifier] playing next track id=${nextTrack.id}');

    await playTrack(track: nextTrack, queue: queue, autoPlay: true);
  }

  Future<void> skipPrevious() async {
    debugPrint('[TrackAudioNotifier] skipPrevious() called');

    if (_isDisposed || _isStopping) {
      debugPrint(
        '[TrackAudioNotifier] skipPrevious ignored because disposed/stopping',
      );
      return;
    }

    final currentId = state.preparedTrackId;
    debugPrint('[TrackAudioNotifier] currentId=$currentId');

    if (currentId == null) return;

    final queue = state.queue;
    debugPrint('[TrackAudioNotifier] queue length=${queue.length}');

    if (queue.isEmpty) return;

    final currentIndex = queue.indexWhere((t) => t.id == currentId);
    debugPrint('[TrackAudioNotifier] currentIndex=$currentIndex');

    if (currentIndex == -1) return;

    final previousIndex = currentIndex - 1;
    debugPrint('[TrackAudioNotifier] previousIndex=$previousIndex');

    if (previousIndex < 0) {
      debugPrint('[TrackAudioNotifier] no previous track');
      return;
    }

    final previousTrack = queue[previousIndex];
    debugPrint(
      '[TrackAudioNotifier] playing previous track id=${previousTrack.id}',
    );

    await playTrack(track: previousTrack, queue: queue, autoPlay: true);
  }

  void addToQueue(Track track) {
    debugPrint(
      '[TrackAudioNotifier] addToQueue() called | trackId=${track.id}',
    );

    if (_isDisposed) {
      debugPrint('[TrackAudioNotifier] addToQueue ignored because disposed');
      return;
    }

    if (!track.isPlayable) {
      debugPrint(
        '[TrackAudioNotifier] addToQueue ignored because track is not playable',
      );
      return;
    }

    final nextQueue = List<Track>.from(state.queue);
    final alreadyInQueue = nextQueue.any((t) => t.id == track.id);

    debugPrint('[TrackAudioNotifier] alreadyInQueue=$alreadyInQueue');

    if (alreadyInQueue) return;

    nextQueue.add(track);
    state = state.copyWith(queue: _sanitizeQueue(nextQueue));

    debugPrint(
      '[TrackAudioNotifier] queue updated | length=${state.queue.length}',
    );
  }

  void removeFromQueue(int trackId) {
    debugPrint(
      '[TrackAudioNotifier] removeFromQueue() called | trackId=$trackId',
    );

    if (_isDisposed) {
      debugPrint(
        '[TrackAudioNotifier] removeFromQueue ignored because disposed',
      );
      return;
    }

    final nextQueue = state.queue.where((t) => t.id != trackId).toList();

    if (nextQueue.length == state.queue.length) {
      debugPrint('[TrackAudioNotifier] track not found in queue');
      return;
    }

    state = state.copyWith(queue: nextQueue);

    debugPrint(
      '[TrackAudioNotifier] queue item removed | length=${state.queue.length}',
    );
  }

  void reorderQueue(int oldIndex, int newIndex) {
    debugPrint(
      '[TrackAudioNotifier] reorderQueue() called | oldIndex=$oldIndex | newIndex=$newIndex',
    );

    if (_isDisposed) {
      debugPrint('[TrackAudioNotifier] reorderQueue ignored because disposed');
      return;
    }

    if (oldIndex < 0 || oldIndex >= state.queue.length) {
      debugPrint('[TrackAudioNotifier] oldIndex out of range');
      return;
    }

    final nextQueue = List<Track>.from(state.queue);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (newIndex < 0 || newIndex >= nextQueue.length) {
      debugPrint('[TrackAudioNotifier] newIndex out of range');
      return;
    }

    final item = nextQueue.removeAt(oldIndex);
    nextQueue.insert(newIndex, item);

    state = state.copyWith(queue: nextQueue);

    debugPrint('[TrackAudioNotifier] queue reordered');
  }

  Future<void> playFromQueueIndex(int index) async {
    debugPrint(
      '[TrackAudioNotifier] playFromQueueIndex() called | index=$index',
    );

    if (_isDisposed || _isStopping) {
      debugPrint(
        '[TrackAudioNotifier] playFromQueueIndex ignored because disposed/stopping',
      );
      return;
    }

    final queue = state.queue;
    debugPrint('[TrackAudioNotifier] queue length=${queue.length}');

    if (index < 0 || index >= queue.length) {
      debugPrint('[TrackAudioNotifier] index out of range');
      return;
    }

    final selected = queue[index];
    debugPrint('[TrackAudioNotifier] selected track id=${selected.id}');

    await playTrack(track: selected, queue: queue, autoPlay: true);
  }

  Future<void> playTrack({
    required Track track,
    List<Track>? queue,
    Duration duration = Duration.zero,
    bool autoPlay = true,
  }) async {
    debugPrint('==============================');
    debugPrint('[TrackAudioNotifier] playTrack() called');
    debugPrint('[TrackAudioNotifier] trackId=${track.id}');
    debugPrint('[TrackAudioNotifier] title=${track.title}');
    debugPrint('[TrackAudioNotifier] isPlayable=${track.isPlayable}');
    debugPrint(
      '[TrackAudioNotifier] normalizedTrackUrl=${track.normalizedTrackUrl}',
    );
    debugPrint('[TrackAudioNotifier] autoPlay=$autoPlay');

    if (_isDisposed || _isStopping) {
      debugPrint(
        '[TrackAudioNotifier] playTrack ignored because disposed/stopping',
      );
      return;
    }

    final trackUrl = track.normalizedTrackUrl;

    if (!track.isPlayable || trackUrl == null) {
      debugPrint(
        '[TrackAudioNotifier] playTrack ignored because track is not playable or URL is null',
      );
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
    debugPrint('[TrackAudioNotifier] play() called');
    debugPrint('[TrackAudioNotifier] isPrepared=${state.isPrepared}');
    debugPrint('[TrackAudioNotifier] isDisposed=$_isDisposed');
    debugPrint('[TrackAudioNotifier] isStopping=$_isStopping');

    if (!state.isPrepared || _isDisposed || _isStopping) {
      debugPrint('[TrackAudioNotifier] play ignored');
      return;
    }

    try {
      debugPrint('[TrackAudioNotifier] calling AudioPlayer.play()');

      unawaited(
        _audioPlayer.play().catchError((Object error, StackTrace stackTrace) {
          debugPrint(
            '[TrackAudioNotifier] AudioPlayer.play() async error: $error',
          );
          debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');

          if (!_isDisposed) {
            state = state.copyWith(isPlaying: false);
          }
        }),
      );
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] AudioPlayer.play() sync error: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');

      if (!_isDisposed) {
        state = state.copyWith(isPlaying: false);
      }
      return;
    }

    if (_isDisposed || _isStopping) {
      debugPrint('[TrackAudioNotifier] play aborted after calling player');
      return;
    }

    state = state.copyWith(isPlaying: true);

    debugPrint('[TrackAudioNotifier] state isPlaying=true');

    _reportPlayStartedIfNeeded();
  }

  Future<void> pause() async {
    debugPrint('[TrackAudioNotifier] pause() called');

    if (!state.isPrepared || _isDisposed || _isStopping) {
      debugPrint('[TrackAudioNotifier] pause ignored');
      return;
    }

    try {
      debugPrint('[TrackAudioNotifier] calling AudioPlayer.pause()');
      await _audioPlayer.pause();
      debugPrint('[TrackAudioNotifier] AudioPlayer.pause() finished');
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] pause failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
    }

    if (_isDisposed) return;

    state = state.copyWith(isPlaying: false);

    debugPrint('[TrackAudioNotifier] state isPlaying=false');
  }

  Future<void> stop({bool resetState = true}) async {
    debugPrint('[TrackAudioNotifier] stop() called | resetState=$resetState');

    if (_isDisposed) {
      debugPrint('[TrackAudioNotifier] stop ignored because disposed');
      return;
    }

    _isStopping = true;

    try {
      if (state.isPrepared) {
        debugPrint('[TrackAudioNotifier] calling AudioPlayer.stop()');
        await _audioPlayer.stop();
        debugPrint('[TrackAudioNotifier] AudioPlayer.stop() finished');
      } else {
        debugPrint('[TrackAudioNotifier] stop skipped because not prepared');
      }
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] stop failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
    }

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

      debugPrint('[TrackAudioNotifier] state reset after stop');
    }

    _isStopping = false;

    debugPrint('[TrackAudioNotifier] stop() finished');
  }

  void onDragStart() {
    debugPrint('[TrackAudioNotifier] onDragStart() called');

    if (_isDisposed) {
      debugPrint('[TrackAudioNotifier] onDragStart ignored because disposed');
      return;
    }

    state = state.copyWith(
      isDragging: true,
      dragProgress: state.progress,
      dragPosition: state.position,
    );

    debugPrint(
      '[TrackAudioNotifier] drag started | progress=${state.progress} | position=${state.position}',
    );
  }

  void onDragUpdate(double progress) {
    debugPrint(
      '[TrackAudioNotifier] onDragUpdate() called | progress=$progress',
    );

    if (_isDisposed) {
      debugPrint('[TrackAudioNotifier] onDragUpdate ignored because disposed');
      return;
    }

    final clamped = progress.clamp(0.0, 1.0);

    final draggedPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clamped).round(),
    );

    state = state.copyWith(
      isDragging: true,
      dragProgress: clamped,
      dragPosition: draggedPosition,
    );

    debugPrint(
      '[TrackAudioNotifier] drag updated | clamped=$clamped | draggedPosition=$draggedPosition',
    );
  }

  Future<void> onDragEnd(double progress) async {
    debugPrint('[TrackAudioNotifier] onDragEnd() called | progress=$progress');

    if (_isDisposed) {
      debugPrint('[TrackAudioNotifier] onDragEnd ignored because disposed');
      return;
    }

    final clamped = progress.clamp(0.0, 1.0);

    final newPosition = Duration(
      milliseconds: (state.duration.inMilliseconds * clamped).round(),
    );

    debugPrint('[TrackAudioNotifier] drag end target position=$newPosition');

    state = state.copyWith(
      isDragging: false,
      dragProgress: null,
      dragPosition: null,
    );

    await seek(newPosition);
  }

  Future<void> seek(Duration position) async {
    debugPrint('[TrackAudioNotifier] seek() called | position=$position');

    if (!state.isPrepared || _isDisposed || _isStopping) {
      debugPrint('[TrackAudioNotifier] seek ignored');
      return;
    }

    final safePosition = position > state.duration ? state.duration : position;

    debugPrint('[TrackAudioNotifier] safePosition=$safePosition');

    try {
      debugPrint('[TrackAudioNotifier] calling AudioPlayer.seek()');
      await _audioPlayer.seek(safePosition);
      debugPrint('[TrackAudioNotifier] AudioPlayer.seek() finished');
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] seek failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
    }

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

    debugPrint(
      '[TrackAudioNotifier] seek state updated | position=${state.position} | progress=${state.progress}',
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
    debugPrint('[TrackAudioNotifier] replay() called');

    await _runSerializedTransition((operationId) async {
      debugPrint('[TrackAudioNotifier] replay transition started');

      if (_isDisposed || _isStopping || state.isPreparing) {
        debugPrint(
          '[TrackAudioNotifier] replay ignored because disposed/stopping/preparing',
        );
        return;
      }

      if (!state.isPrepared) {
        debugPrint('[TrackAudioNotifier] replay ignored because not prepared');
        return;
      }

      if (state.preparedTrackUrl == null || state.preparedTrackId == null) {
        debugPrint(
          '[TrackAudioNotifier] replay ignored because prepared data is null',
        );
        return;
      }

      _isStopping = true;
      var didRestart = false;

      final preparedTrackId = state.preparedTrackId!;
      final preparedUrl = state.preparedTrackUrl!;
      final currentTrack = state.currentTrack;

      debugPrint(
        '[TrackAudioNotifier] replay preparedTrackId=$preparedTrackId',
      );
      debugPrint('[TrackAudioNotifier] replay preparedUrl=$preparedUrl');

      try {
        debugPrint('[TrackAudioNotifier] replay: stopping player');
        await _audioPlayer.stop();

        if (_isDisposed || operationId != _operationGeneration) {
          debugPrint('[TrackAudioNotifier] replay cancelled after stop');
          return;
        }

        debugPrint('[TrackAudioNotifier] replay: disposing player');
        await _disposeCurrentPlayer();

        if (_isDisposed || operationId != _operationGeneration) {
          debugPrint('[TrackAudioNotifier] replay cancelled after dispose');
          return;
        }

        debugPrint('[TrackAudioNotifier] replay: creating new player');
        _createPlayer();

        debugPrint('[TrackAudioNotifier] replay: setting source again');
        await _setSource(
          trackId: preparedTrackId,
          urlOrPath: preparedUrl,
          track: currentTrack,
        );

        if (_isDisposed || operationId != _operationGeneration) {
          debugPrint('[TrackAudioNotifier] replay cancelled after setSource');
          return;
        }

        debugPrint(
          '[TrackAudioNotifier] replay: re-listening to player streams',
        );
        _listenToPlayer();

        debugPrint('[TrackAudioNotifier] replay: seeking to zero');
        await _audioPlayer.seek(Duration.zero);

        if (_isDisposed || operationId != _operationGeneration) {
          debugPrint('[TrackAudioNotifier] replay cancelled after seek');
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

        debugPrint('[TrackAudioNotifier] replay restart success');
      } catch (error, stackTrace) {
        debugPrint('[TrackAudioNotifier] replay failed: $error');
        debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');

        if (!_isDisposed && operationId == _operationGeneration) {
          state = state.copyWith(isPlaying: false);
        }
      } finally {
        _isStopping = false;
        debugPrint('[TrackAudioNotifier] replay finally | isStopping=false');
      }

      if (_isDisposed || !didRestart || operationId != _operationGeneration) {
        debugPrint('[TrackAudioNotifier] replay will not resume play');
        return;
      }

      debugPrint('[TrackAudioNotifier] replay calling play()');
      await play();
    });
  }

  Future<Duration?> _setSource({
    required int trackId,
    required String urlOrPath,
    Track? track,
  }) async {
    debugPrint('[TrackAudioNotifier] _setSource() called');
    debugPrint('[TrackAudioNotifier] trackId=$trackId');
    debugPrint('[TrackAudioNotifier] urlOrPath=$urlOrPath');

    final normalizedSource = urlOrPath.trim();

    if (normalizedSource.isEmpty) {
      debugPrint('[TrackAudioNotifier] ERROR: source is empty');
      throw const FormatException('Track source is empty');
    }

    final mediaItem = _buildMediaItem(
      trackId: trackId,
      urlOrPath: normalizedSource,
      track: track,
    );

    debugPrint('[TrackAudioNotifier] mediaItem built');
    debugPrint('[TrackAudioNotifier] mediaItem.title=${mediaItem.title}');
    debugPrint('[TrackAudioNotifier] mediaItem.artist=${mediaItem.artist}');

    final uri = Uri.tryParse(normalizedSource);

    debugPrint('[TrackAudioNotifier] parsed uri=$uri');
    debugPrint('[TrackAudioNotifier] uri.hasScheme=${uri?.hasScheme}');

    try {
      if (uri != null && uri.hasScheme) {
        debugPrint('[TrackAudioNotifier] source is network URL');
        debugPrint(
          '[TrackAudioNotifier] calling setAudioSource(network, preload:false)',
        );

        final result = await _audioPlayer.setAudioSource(
          AudioSource.uri(uri, tag: mediaItem),
          preload: false,
        );

        debugPrint('[TrackAudioNotifier] network source set successfully');
        debugPrint('[TrackAudioNotifier] loadedDuration=$result');

        return result;
      }

      debugPrint('[TrackAudioNotifier] source is local file path');
      debugPrint(
        '[TrackAudioNotifier] calling setAudioSource(file, preload:false)',
      );

      final result = await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.file(normalizedSource), tag: mediaItem),
        preload: false,
      );

      debugPrint('[TrackAudioNotifier] local source set successfully');
      debugPrint('[TrackAudioNotifier] loadedDuration=$result');

      return result;
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] setAudioSource failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
      rethrow;
    }
  }

  MediaItem _buildMediaItem({
    required int trackId,
    required String urlOrPath,
    Track? track,
  }) {
    debugPrint('[TrackAudioNotifier] _buildMediaItem() called');

    final title = track?.title.trim();
    final artistName = track?.artist.displayName ?? track?.artist.username;
    final coverUrl = track?.coverUrl?.trim();

    debugPrint('[TrackAudioNotifier] title=$title');
    debugPrint('[TrackAudioNotifier] artistName=$artistName');
    debugPrint('[TrackAudioNotifier] coverUrl=$coverUrl');

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
    debugPrint('[TrackAudioNotifier] setVolume() called | volume=$volume');
    _playerVolume = volume;

    if (_isDisposed || _isStopping) {
      debugPrint(
        '[TrackAudioNotifier] setVolume ignored because disposed/stopping',
      );
      return;
    }

    try {
      await _audioPlayer.setVolume(volume);
      debugPrint('[TrackAudioNotifier] volume set successfully');
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] setVolume failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
    }
  }

  void _reportPlayStartedIfNeeded() {
    debugPrint('[TrackAudioNotifier] _reportPlayStartedIfNeeded() called');

    final trackId = state.preparedTrackId;

    if (trackId == null) {
      debugPrint('[TrackAudioNotifier] no preparedTrackId, cannot report play');
      return;
    }

    final alreadyReported =
        _hasReportedPlayForPreparedTrack && _reportedPlayTrackId == trackId;

    debugPrint('[TrackAudioNotifier] trackId=$trackId');
    debugPrint('[TrackAudioNotifier] alreadyReported=$alreadyReported');

    if (alreadyReported) {
      return;
    }

    _hasReportedPlayForPreparedTrack = true;
    _reportedPlayTrackId = trackId;

    debugPrint('[TrackAudioNotifier] reporting play started');

    unawaited(_recordTrackPlayStarted(trackId));
  }

  void _reportTrackCompleted() {
    debugPrint('[TrackAudioNotifier] _reportTrackCompleted() called');

    final trackId = state.preparedTrackId;

    if (trackId == null) {
      debugPrint(
        '[TrackAudioNotifier] no preparedTrackId, cannot report completed',
      );
      return;
    }

    debugPrint('[TrackAudioNotifier] reporting completed for trackId=$trackId');

    unawaited(_recordTrackCompleted(trackId));
  }

  Future<void> _recordTrackPlayStarted(int trackId) async {
    debugPrint(
      '[TrackAudioNotifier] _recordTrackPlayStarted() called | trackId=$trackId',
    );

    final repository = ref.read(historyRepositoryProvider);

    try {
      await repository.incrementPlayCount(trackId: trackId);
      debugPrint('[TrackAudioNotifier] incrementPlayCount success');
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] incrementPlayCount failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
    }
  }

  Future<void> _recordTrackCompleted(int trackId) async {
    debugPrint(
      '[TrackAudioNotifier] _recordTrackCompleted() called | trackId=$trackId',
    );

    final repository = ref.read(historyRepositoryProvider);

    try {
      await repository.markTrackCompleted(trackId: trackId);
      debugPrint('[TrackAudioNotifier] markTrackCompleted success');
    } catch (error, stackTrace) {
      debugPrint('[TrackAudioNotifier] markTrackCompleted failed: $error');
      debugPrint('[TrackAudioNotifier] stackTrace: $stackTrace');
    }
  }

  List<Track> _sanitizeQueue(List<Track> queue, {Track? currentTrack}) {
    debugPrint('[TrackAudioNotifier] _sanitizeQueue() called');
    debugPrint('[TrackAudioNotifier] input queue length=${queue.length}');
    debugPrint('[TrackAudioNotifier] currentTrack id=${currentTrack?.id}');

    final sanitizedQueue = <Track>[];
    final seenTrackIds = <int>{};

    for (final track in queue) {
      if (!track.isPlayable) {
        debugPrint(
          '[TrackAudioNotifier] queue skip non-playable track id=${track.id}',
        );
        continue;
      }

      if (!seenTrackIds.add(track.id)) {
        debugPrint(
          '[TrackAudioNotifier] queue skip duplicate track id=${track.id}',
        );
        continue;
      }

      sanitizedQueue.add(track);
    }

    if (currentTrack != null &&
        currentTrack.isPlayable &&
        seenTrackIds.add(currentTrack.id)) {
      sanitizedQueue.insert(0, currentTrack);
      debugPrint('[TrackAudioNotifier] current track inserted into queue');
    }

    debugPrint(
      '[TrackAudioNotifier] sanitized queue length=${sanitizedQueue.length}',
    );

    return sanitizedQueue;
  }
}
