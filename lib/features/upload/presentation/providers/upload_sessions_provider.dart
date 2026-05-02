import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../domain/entities/track_upload_status.dart';
import 'upload_repository_provider.dart';

class UploadSession {
  const UploadSession({
    required this.uploadId,
    required this.track,
    required this.state,
    required this.progressPercentage,
    this.stepName,
    this.errorMessage,
  });

  final String uploadId;
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
    Track? track,
    TrackUploadState? state,
    int? progressPercentage,
    String? stepName,
    String? errorMessage,
  }) {
    return UploadSession(
      uploadId: uploadId,
      track: track ?? this.track,
      state: state ?? this.state,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      stepName: stepName ?? this.stepName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final uploadSessionsProvider =
    NotifierProvider<UploadSessionsNotifier, Map<String, UploadSession>>(
      UploadSessionsNotifier.new,
    );

final uploadSessionByTrackIdProvider = Provider.family<UploadSession?, int>((
  ref,
  int trackId,
) {
  final sessions = ref.watch(uploadSessionsProvider);

  for (final session in sessions.values) {
    if (session.trackId == trackId) {
      return session;
    }
  }

  return null;
});

class UploadSessionsNotifier extends Notifier<Map<String, UploadSession>> {
  final Map<String, StreamSubscription<TrackUploadStatus>> _subscriptions =
      <String, StreamSubscription<TrackUploadStatus>>{};

  final Map<String, void Function()> _cancelUploadStatusSubscriptions =
      <String, void Function()>{};

  // Stores statuses that arrive before the Track object is available.
  final Map<String, TrackUploadStatus> _latestStatusByUploadId =
      <String, TrackUploadStatus>{};

  @override
  Map<String, UploadSession> build() {
    ref.onDispose(() {
      for (final cancelUploadStatus
          in _cancelUploadStatusSubscriptions.values) {
        cancelUploadStatus();
      }

      for (final subscription in _subscriptions.values) {
        subscription.cancel();
      }

      _subscriptions.clear();
      _cancelUploadStatusSubscriptions.clear();
      _latestStatusByUploadId.clear();
    });

    return <String, UploadSession>{};
  }

  void watchUploadStatusBeforeTrack({required String uploadId}) {
    if (_subscriptions.containsKey(uploadId)) {
      return;
    }

    final repository = ref.read(uploadRepositoryProvider);

    try {
      _cancelUploadStatusSubscriptions[uploadId] = () {
        repository.cancelUploadStatusSubscription(uploadId);
      };

      final stream = repository.watchUploadStatus(uploadId);

      _subscriptions[uploadId] = stream.listen(
        (status) {
          _latestStatusByUploadId[uploadId] = status;

          final currentSession = state[uploadId];

          if (currentSession == null) {
            return;
          }

          unawaited(_handleStatus(uploadId, status));
        },
        onError: (Object error, StackTrace stackTrace) {
          _handleStreamError(uploadId, error);
        },
        onDone: () {},
        cancelOnError: false,
      );
    } catch (error) {
      _handleStreamError(uploadId, error);
    }
  }

  void trackUpload({required String uploadId, required Track track}) {
    final cachedStatus = _latestStatusByUploadId[uploadId];

    final initialUploadState =
        cachedStatus?.state ?? TrackUploadState.uploading;

    final initialProgress = cachedStatus?.progressPercentage ?? 0;

    final initialTrack = _resolveTrack(
      currentTrack: track.copyWith(state: TrackStatus.processing),
      uploadedTrack: cachedStatus?.trackResponse,
      uploadState: initialUploadState,
    );

    state = <String, UploadSession>{
      ...state,
      uploadId: UploadSession(
        uploadId: uploadId,
        track: initialTrack,
        state: initialUploadState,
        progressPercentage: initialProgress,
        stepName: cachedStatus?.stepName,
        errorMessage: cachedStatus?.errorMessage,
      ),
    };

    if (cachedStatus != null) {
      unawaited(_handleStatus(uploadId, cachedStatus));
    }

    if (_subscriptions.containsKey(uploadId)) {
      return;
    }

    final repository = ref.read(uploadRepositoryProvider);

    try {
      final statusWatchKey = uploadId;

      _cancelUploadStatusSubscriptions[uploadId] = () {
        repository.cancelUploadStatusSubscription(statusWatchKey);
      };

      final stream = repository.watchUploadStatus(statusWatchKey);

      _subscriptions[uploadId] = stream.listen(
        (status) {
          _latestStatusByUploadId[uploadId] = status;
          unawaited(_handleStatus(uploadId, status));
        },
        onError: (Object error, StackTrace stackTrace) {
          _handleStreamError(uploadId, error);
        },
        onDone: () {},
        cancelOnError: false,
      );
    } catch (error) {
      _handleStreamError(uploadId, error);
    }
  }

  Future<void> _handleStatus(String uploadId, TrackUploadStatus status) async {
    _latestStatusByUploadId[uploadId] = status;

    final currentSession = state[uploadId];

    if (currentSession == null) {
      return;
    }

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

    state = <String, UploadSession>{...state, uploadId: nextSession};

    final uploadsNotifier = ref.read(uploadsProvider.notifier);

    switch (status.state) {
      case TrackUploadState.uploading:
        uploadsNotifier.setTrackState(nextTrack.id, TrackStatus.processing);
        break;

      case TrackUploadState.processing:
        uploadsNotifier.setTrackState(nextTrack.id, TrackStatus.processing);
        break;

      case TrackUploadState.finished:
        if (status.trackResponse != null) {
          uploadsNotifier.upsertTrack(nextTrack);
        } else {
          await uploadsNotifier.refreshTrack(nextTrack.id);
          uploadsNotifier.preserveTrackAccessIfMoreRestrictive(
            trackId: nextTrack.id,
            preferredAccess: nextTrack.access,
          );
        }

        _removeCompletedSession(uploadId);
        break;

      case TrackUploadState.failed:
        uploadsNotifier.upsertTrack(nextTrack);

        _removeCompletedSession(uploadId);
        break;
    }
  }

  void _handleStreamError(String uploadId, Object error) {
    final currentSession = state[uploadId];

    if (currentSession == null) {
      return;
    }

    state = <String, UploadSession>{
      ...state,
      uploadId: currentSession.copyWith(errorMessage: error.toString()),
    };

    _cancelSubscription(uploadId);
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

  void _removeCompletedSession(String uploadId) {
    _cancelSubscription(uploadId);

    final nextState = Map<String, UploadSession>.from(state);
    nextState.remove(uploadId);
    state = nextState;

    _latestStatusByUploadId.remove(uploadId);
  }

  void _cancelSubscription(String uploadId) {
    final subscription = _subscriptions.remove(uploadId);
    if (subscription == null) {
    } else {
      subscription.cancel();
    }

    final cancelRepositorySubscription = _cancelUploadStatusSubscriptions
        .remove(uploadId);

    if (cancelRepositorySubscription == null) {
    } else {
      cancelRepositorySubscription();
    }
  }

  void cancelUploadStatusWatch(String uploadId) {
    _cancelSubscription(uploadId);
    _latestStatusByUploadId.remove(uploadId);
  }
}
