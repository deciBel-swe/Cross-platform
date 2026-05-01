import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../domain/entities/track_upload_status.dart';
import 'upload_repository_provider.dart';

class UploadSession {
  const UploadSession({
    this.uploadId,
    required this.track,
    required this.state,
    required this.progressPercentage,
    this.stepName,
    this.errorMessage,
  });

  final String? uploadId;
  final Track track;
  final TrackUploadState state;
  final int progressPercentage;
  final String? stepName;
  final String? errorMessage;

  int get trackId => track.id;
  String get title => track.title;

  bool get isActive =>
      state == TrackUploadState.uploading ||
      state == TrackUploadState.processing;

  bool get isFailed => state == TrackUploadState.failed;
  bool get isFinished => state == TrackUploadState.finished;

  UploadSession copyWith({
    String? uploadId,
    Track? track,
    TrackUploadState? state,
    int? progressPercentage,
    String? stepName,
    String? errorMessage,
  }) {
    return UploadSession(
      uploadId: uploadId ?? this.uploadId,
      track: track ?? this.track,
      state: state ?? this.state,
      // Uses the existing percentage if a polling fallback returns null
      progressPercentage: progressPercentage ?? this.progressPercentage,
      stepName: stepName ?? this.stepName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final uploadSessionsProvider =
    NotifierProvider<UploadSessionsNotifier, Map<int, UploadSession>>(
      UploadSessionsNotifier.new,
    );

final uploadSessionByTrackIdProvider = Provider.family<UploadSession?, int>((
  ref,
  int trackId,
) {
  return ref.watch(uploadSessionsProvider)[trackId];
});

class UploadSessionsNotifier extends Notifier<Map<int, UploadSession>> {
  // Master map of all active WebSocket streams (using UUID as the key)
  final Map<String, StreamSubscription<TrackUploadStatus>> _activeStreams = {};
  final Map<String, void Function()> _cancelCallbacks = {};
  final Map<String, TrackUploadStatus> _statusCache = {};
  
  // Maps the temporary UUID string to the final UI trackId
  final Map<String, int> _watchKeyToTrackId = {};

  @override
  Map<int, UploadSession> build() {
    ref.onDispose(() {
      for (final cancel in _cancelCallbacks.values) cancel();
      for (final sub in _activeStreams.values) sub.cancel();
      _activeStreams.clear();
      _cancelCallbacks.clear();
      _statusCache.clear();
      _watchKeyToTrackId.clear();
    });

    return <int, UploadSession>{};
  }

  void startWatchingBeforeUpload(String watchKey) {
    if (_activeStreams.containsKey(watchKey)) return;
    
    final repository = ref.read(uploadRepositoryProvider);
    
    _cancelCallbacks[watchKey] = () {
      repository.cancelUploadStatusSubscription(watchKey);
    };

    _activeStreams[watchKey] = repository.watchUploadStatus(watchKey).listen(
      (status) {
        _statusCache[watchKey] = status;
        
        // If the track HTTP upload has finished and linked the ID, route it to the UI instantly!
        final linkedTrackId = _watchKeyToTrackId[watchKey];
        if (linkedTrackId != null) {
          _handleStatus(linkedTrackId, status);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        final linkedTrackId = _watchKeyToTrackId[watchKey];
        if (linkedTrackId != null) {
          _handleStreamError(linkedTrackId, error);
        } 
      },
      onDone: () async {
        _activeStreams.remove(watchKey);
        _cancelCallbacks.remove(watchKey);

        final linkedTrackId = _watchKeyToTrackId[watchKey];
        if (linkedTrackId != null) {
          ref.read(uploadsProvider.notifier).refreshTrack(linkedTrackId);

          Future.delayed(const Duration(seconds: 2), () {
            final session = state[linkedTrackId];

            
            if (session != null && !session.isFinished && !session.isFailed) {
              final correctWatchKey = session.uploadId ?? watchKey;
              _watchKeyToTrackId[correctWatchKey] = linkedTrackId;
              startWatchingBeforeUpload(correctWatchKey);
            }
          });
        }
      },
      cancelOnError: false,
    );
  }

  void trackUpload({String? uploadId, required Track track}) {
    final trackId = track.id;
    
    final existingSession = state[trackId];
    final activeUploadId = uploadId ?? existingSession?.uploadId;
    final watchKey = activeUploadId ?? trackId.toString();

    // 1. Link the UUID stream to the UI trackId
    _watchKeyToTrackId[watchKey] = trackId;

    // 2. Fetch the latest progress the stream buffered while the HTTP upload was running
    final cachedStatus = _statusCache[watchKey];
    final initialUploadState = cachedStatus?.state ?? TrackUploadState.uploading;
    final initialProgress = cachedStatus?.progressPercentage ?? 0;

    final initialTrack = _resolveTrack(
      currentTrack: track.copyWith(state: TrackStatus.processing),
      uploadedTrack: cachedStatus?.trackResponse,
      uploadState: initialUploadState,
    );

    state = <int, UploadSession>{
      ...state,
      trackId: UploadSession(
        uploadId: activeUploadId,
        track: initialTrack,
        state: initialUploadState,
        progressPercentage: initialProgress,
        stepName: cachedStatus?.stepName,
        errorMessage: cachedStatus?.errorMessage,
      ),
    };

    // 3. Process the buffered status
    if (cachedStatus != null) {
      _handleStatus(trackId, cachedStatus);
    }

    // Stop if it already finished before trackUpload was even called
    if (cachedStatus?.state == TrackUploadState.finished || 
        cachedStatus?.state == TrackUploadState.failed) {
      return;
    }

    // 4. If the app restarted and no stream exists, open one (avoids reconnecting an active stream!)
    if (!_activeStreams.containsKey(watchKey)) {
      startWatchingBeforeUpload(watchKey);
    }
  }

  Future<void> _handleStatus(int trackId, TrackUploadStatus status) async {
    _statusCache[_watchKeyToTrackId.keys.firstWhere((k) => _watchKeyToTrackId[k] == trackId, orElse: () => trackId.toString())] = status;
    
    final currentSession = state[trackId];
    if (currentSession == null) return;

    final nextTrack = _resolveTrack(
      currentTrack: currentSession.track,
      uploadedTrack: status.trackResponse,
      uploadState: status.state,
    );

    final nextSession = currentSession.copyWith(
      track: nextTrack,
      state: status.state,
      progressPercentage: status.progressPercentage,
      stepName: status.stepName,
      errorMessage: status.errorMessage,
    );

    state = <int, UploadSession>{...state, trackId: nextSession};

    final uploadsNotifier = ref.read(uploadsProvider.notifier);

    switch (status.state) {
      case TrackUploadState.uploading:
      case TrackUploadState.processing:
        uploadsNotifier.setTrackState(nextTrack.id, TrackStatus.processing);
        break;

      case TrackUploadState.finished:
        if (status.trackResponse != null) {
          uploadsNotifier.upsertTrack(nextTrack);
        } else {
          await uploadsNotifier.refreshTrack(nextTrack.id);
        }
        _removeCompletedSession(trackId);
        break;

      case TrackUploadState.failed:
        uploadsNotifier.upsertTrack(nextTrack);
        _removeCompletedSession(trackId);
        break;
    }
  }

  void _handleStreamError(int trackId, Object error) {
    final currentSession = state[trackId];
    if (currentSession == null) return;

    state = <int, UploadSession>{
      ...state,
      trackId: currentSession.copyWith(

        errorMessage: 'Connection lost or timeout: ${error.toString()}',
        state: TrackUploadState.failed,
        ),
    };

    _cancelSubscription(trackId);
  }

  Track _resolveTrack({
    required Track currentTrack,
    required Track? uploadedTrack,
    required TrackUploadState uploadState,
  }) {
    final source = uploadedTrack ?? currentTrack;
    final nextState = switch (uploadState) {
      TrackUploadState.failed => TrackStatus.failed,
      TrackUploadState.finished => TrackStatus.finished,
      TrackUploadState.uploading ||
      TrackUploadState.processing => TrackStatus.processing,
    };

    return source.copyWith(state: nextState);
  }

  void _removeCompletedSession(int trackId) {
    final currentSession = state[trackId];
    final watchKey = currentSession?.uploadId ?? trackId.toString();

    _activeStreams.remove(watchKey)?.cancel();
    _cancelCallbacks.remove(watchKey)?.call();
    _watchKeyToTrackId.remove(watchKey);
    _statusCache.remove(watchKey);

    final nextState = Map<int, UploadSession>.from(state);
    nextState.remove(trackId);
    state = nextState;
  }

  void _cancelSubscription(int trackId) {
    final currentSession = state[trackId];
    final watchKey = currentSession?.uploadId ?? trackId.toString();
    
    _activeStreams.remove(watchKey)?.cancel();
    _cancelCallbacks.remove(watchKey)?.call();
  }

  void cancelUploadStatusWatch(int trackId) {
    _cancelSubscription(trackId);
    
    final currentSession = state[trackId];
    final watchKey = currentSession?.uploadId ?? trackId.toString();
    _statusCache.remove(watchKey);
  }
}