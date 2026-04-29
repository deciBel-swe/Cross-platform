import 'dart:async';

import 'package:flutter/foundation.dart';
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
    debugPrint('[UploadSessionsNotifier] build() called');

    ref.onDispose(() {
      debugPrint('[UploadSessionsNotifier] dispose() called');

      for (final cancelUploadStatus
          in _cancelUploadStatusSubscriptions.values) {
        debugPrint(
          '[UploadSessionsNotifier] cancelling repository status subscription',
        );
        cancelUploadStatus();
      }

      for (final subscription in _subscriptions.values) {
        debugPrint('[UploadSessionsNotifier] cancelling stream subscription');
        subscription.cancel();
      }

      _subscriptions.clear();
      _cancelUploadStatusSubscriptions.clear();
      _latestStatusByUploadId.clear();

      debugPrint('[UploadSessionsNotifier] dispose finished');
    });

    return <String, UploadSession>{};
  }

  void watchUploadStatusBeforeTrack({required String uploadId}) {
    debugPrint('==============================');
    debugPrint(
      '[UploadSessionsNotifier] watchUploadStatusBeforeTrack() called',
    );
    debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');

    if (_subscriptions.containsKey(uploadId)) {
      debugPrint(
        '[UploadSessionsNotifier] pre-subscription already exists for uploadId: $uploadId',
      );
      return;
    }

    final repository = ref.read(uploadRepositoryProvider);

    try {
      debugPrint(
        '[UploadSessionsNotifier] creating pre-subscription using uploadId',
      );

      _cancelUploadStatusSubscriptions[uploadId] = () {
        debugPrint(
          '[UploadSessionsNotifier] repository.cancelUploadStatusSubscription() called for uploadId: $uploadId',
        );
        repository.cancelUploadStatusSubscription(uploadId);
      };

      debugPrint(
        '[UploadSessionsNotifier] before pre watchUploadStatus($uploadId)',
      );

      final stream = repository.watchUploadStatus(uploadId);

      _subscriptions[uploadId] = stream.listen(
        (status) {
          debugPrint('------------------------------');
          debugPrint(
            '[UploadSessionsNotifier] pre-subscription status emitted',
          );
          debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
          debugPrint('[UploadSessionsNotifier] status.state: ${status.state}');
          debugPrint(
            '[UploadSessionsNotifier] status.progressPercentage: ${status.progressPercentage}',
          );
          debugPrint(
            '[UploadSessionsNotifier] status.stepName: ${status.stepName}',
          );
          debugPrint(
            '[UploadSessionsNotifier] status.errorMessage: ${status.errorMessage}',
          );
          debugPrint(
            '[UploadSessionsNotifier] status.trackResponse id: ${status.trackResponse?.id}',
          );

          _latestStatusByUploadId[uploadId] = status;

          final currentSession = state[uploadId];

          if (currentSession == null) {
            debugPrint(
              '[UploadSessionsNotifier] no session yet, caching status until trackUpload()',
            );
            return;
          }

          unawaited(_handleStatus(uploadId, status));
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
          debugPrint('[UploadSessionsNotifier] pre-subscription stream error');
          debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
          debugPrint('[UploadSessionsNotifier] error: $error');
          debugPrint('[UploadSessionsNotifier] stackTrace: $stackTrace');

          _handleStreamError(uploadId, error);
        },
        onDone: () {
          debugPrint('------------------------------');
          debugPrint('[UploadSessionsNotifier] pre-subscription stream done');
          debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
        },
        cancelOnError: false,
      );

      debugPrint(
        '[UploadSessionsNotifier] pre-subscription saved for uploadId: $uploadId',
      );
    } catch (error, stackTrace) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint(
        '[UploadSessionsNotifier] exception while creating pre-subscription',
      );
      debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
      debugPrint('[UploadSessionsNotifier] error: $error');
      debugPrint('[UploadSessionsNotifier] stackTrace: $stackTrace');

      _handleStreamError(uploadId, error);
    }
  }

  void trackUpload({required String uploadId, required Track track}) {
    debugPrint('==============================');
    debugPrint('[UploadSessionsNotifier] trackUpload() called');
    debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
    debugPrint('[UploadSessionsNotifier] trackId: ${track.id}');
    debugPrint('[UploadSessionsNotifier] trackTitle: ${track.title}');
    debugPrint(
      '[UploadSessionsNotifier] current sessions count: ${state.length}',
    );
    debugPrint(
      '[UploadSessionsNotifier] existing subscriptions: ${_subscriptions.keys.toList()}',
    );

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

    debugPrint('[UploadSessionsNotifier] session added to state');
    debugPrint(
      '[UploadSessionsNotifier] sessions count after add: ${state.length}',
    );

    if (cachedStatus != null) {
      debugPrint(
        '[UploadSessionsNotifier] applying cached status after session creation',
      );
      unawaited(_handleStatus(uploadId, cachedStatus));
    }

    if (_subscriptions.containsKey(uploadId)) {
      debugPrint(
        '[UploadSessionsNotifier] subscription already exists for uploadId: $uploadId',
      );
      debugPrint(
        '[UploadSessionsNotifier] using existing pre-subscription listener',
      );
      return;
    }

    debugPrint(
      '[UploadSessionsNotifier] no existing subscription, creating listener',
    );

    final repository = ref.read(uploadRepositoryProvider);

    try {
      debugPrint('[UploadSessionsNotifier] repository read successfully');

      final statusWatchKey = uploadId;

      debugPrint('[UploadSessionsNotifier] original uploadId: $uploadId');
      debugPrint('[UploadSessionsNotifier] trackId: ${track.id}');
      debugPrint('[UploadSessionsNotifier] statusWatchKey: $statusWatchKey');
      debugPrint('[UploadSessionsNotifier] using uploadId for websocket topic');

      _cancelUploadStatusSubscriptions[uploadId] = () {
        debugPrint(
          '[UploadSessionsNotifier] repository.cancelUploadStatusSubscription() called for statusWatchKey: $statusWatchKey',
        );
        repository.cancelUploadStatusSubscription(statusWatchKey);
      };

      debugPrint(
        '[UploadSessionsNotifier] before watchUploadStatus($statusWatchKey)',
      );

      final stream = repository.watchUploadStatus(statusWatchKey);

      debugPrint(
        '[UploadSessionsNotifier] stream created for statusWatchKey: $statusWatchKey',
      );
      debugPrint('[UploadSessionsNotifier] before stream.listen()');

      _subscriptions[uploadId] = stream.listen(
        (status) {
          debugPrint('------------------------------');
          debugPrint('[UploadSessionsNotifier] stream emitted status');
          debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
          debugPrint(
            '[UploadSessionsNotifier] statusWatchKey: $statusWatchKey',
          );
          debugPrint('[UploadSessionsNotifier] status.state: ${status.state}');
          debugPrint(
            '[UploadSessionsNotifier] status.progressPercentage: ${status.progressPercentage}',
          );
          debugPrint(
            '[UploadSessionsNotifier] status.stepName: ${status.stepName}',
          );
          debugPrint(
            '[UploadSessionsNotifier] status.errorMessage: ${status.errorMessage}',
          );
          debugPrint(
            '[UploadSessionsNotifier] status.trackResponse id: ${status.trackResponse?.id}',
          );

          _latestStatusByUploadId[uploadId] = status;
          unawaited(_handleStatus(uploadId, status));
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
          debugPrint('[UploadSessionsNotifier] stream error');
          debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
          debugPrint(
            '[UploadSessionsNotifier] statusWatchKey: $statusWatchKey',
          );
          debugPrint('[UploadSessionsNotifier] error: $error');
          debugPrint('[UploadSessionsNotifier] stackTrace: $stackTrace');

          _handleStreamError(uploadId, error);
        },
        onDone: () {
          debugPrint('------------------------------');
          debugPrint('[UploadSessionsNotifier] stream done');
          debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
          debugPrint(
            '[UploadSessionsNotifier] statusWatchKey: $statusWatchKey',
          );
        },
        cancelOnError: false,
      );

      debugPrint('[UploadSessionsNotifier] after stream.listen()');
      debugPrint(
        '[UploadSessionsNotifier] subscription saved for uploadId: $uploadId',
      );
    } catch (error, stackTrace) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint(
        '[UploadSessionsNotifier] exception while creating subscription',
      );
      debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
      debugPrint('[UploadSessionsNotifier] error: $error');
      debugPrint('[UploadSessionsNotifier] stackTrace: $stackTrace');

      _handleStreamError(uploadId, error);
    }
  }

  Future<void> _handleStatus(String uploadId, TrackUploadStatus status) async {
    debugPrint('[UploadSessionsNotifier] _handleStatus() called');
    debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
    debugPrint('[UploadSessionsNotifier] incoming state: ${status.state}');

    _latestStatusByUploadId[uploadId] = status;

    final currentSession = state[uploadId];

    if (currentSession == null) {
      debugPrint(
        '[UploadSessionsNotifier] no current session found for uploadId: $uploadId',
      );
      debugPrint('[UploadSessionsNotifier] ignoring status for now');
      return;
    }

    debugPrint('[UploadSessionsNotifier] current session found');
    debugPrint(
      '[UploadSessionsNotifier] current trackId: ${currentSession.track.id}',
    );
    debugPrint(
      '[UploadSessionsNotifier] current upload state: ${currentSession.state}',
    );

    final nextTrack = _resolveTrack(
      currentTrack: currentSession.track,
      uploadedTrack: status.trackResponse,
      uploadState: status.state,
    );

    debugPrint('[UploadSessionsNotifier] next track resolved');
    debugPrint('[UploadSessionsNotifier] next trackId: ${nextTrack.id}');
    debugPrint('[UploadSessionsNotifier] next track state: ${nextTrack.state}');

    final nextSession = currentSession.copyWith(
      track: nextTrack,
      state: status.state,
      progressPercentage: status.progressPercentage,
      stepName: status.stepName,
      errorMessage: status.errorMessage,
    );

    state = <String, UploadSession>{...state, uploadId: nextSession};

    debugPrint('[UploadSessionsNotifier] session state updated');
    debugPrint(
      '[UploadSessionsNotifier] progress: ${nextSession.progressPercentage}%',
    );

    final uploadsNotifier = ref.read(uploadsProvider.notifier);

    switch (status.state) {
      case TrackUploadState.uploading:
        debugPrint('[UploadSessionsNotifier] status is uploading');
        debugPrint(
          '[UploadSessionsNotifier] setting track state to processing',
        );
        uploadsNotifier.setTrackState(nextTrack.id, TrackStatus.processing);
        break;

      case TrackUploadState.processing:
        debugPrint('[UploadSessionsNotifier] status is processing');
        debugPrint(
          '[UploadSessionsNotifier] setting track state to processing',
        );
        uploadsNotifier.setTrackState(nextTrack.id, TrackStatus.processing);
        break;

      case TrackUploadState.finished:
        debugPrint('[UploadSessionsNotifier] status is finished');

        if (status.trackResponse != null) {
          debugPrint('[UploadSessionsNotifier] trackResponse exists');
          debugPrint('[UploadSessionsNotifier] upserting finished track');
          uploadsNotifier.upsertTrack(nextTrack);
        } else {
          debugPrint('[UploadSessionsNotifier] trackResponse is null');
          debugPrint(
            '[UploadSessionsNotifier] refreshing track by id: ${nextTrack.id}',
          );
          await uploadsNotifier.refreshTrack(nextTrack.id);
        }

        debugPrint('[UploadSessionsNotifier] removing completed session');
        _removeCompletedSession(uploadId);
        break;

      case TrackUploadState.failed:
        debugPrint('[UploadSessionsNotifier] status is failed');
        debugPrint('[UploadSessionsNotifier] upserting failed track');
        uploadsNotifier.upsertTrack(nextTrack);

        debugPrint('[UploadSessionsNotifier] removing failed session');
        _removeCompletedSession(uploadId);
        break;
    }
  }

  void _handleStreamError(String uploadId, Object error) {
    debugPrint('[UploadSessionsNotifier] _handleStreamError() called');
    debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');
    debugPrint('[UploadSessionsNotifier] error: $error');

    final currentSession = state[uploadId];

    if (currentSession == null) {
      debugPrint(
        '[UploadSessionsNotifier] no current session found while handling error',
      );
      return;
    }

    state = <String, UploadSession>{
      ...state,
      uploadId: currentSession.copyWith(errorMessage: error.toString()),
    };

    debugPrint('[UploadSessionsNotifier] error message saved in session');
    debugPrint('[UploadSessionsNotifier] cancelling subscription after error');

    _cancelSubscription(uploadId);
  }

  Track _resolveTrack({
    required Track currentTrack,
    required Track? uploadedTrack,
    required TrackUploadState uploadState,
  }) {
    debugPrint('[UploadSessionsNotifier] _resolveTrack() called');
    debugPrint('[UploadSessionsNotifier] currentTrack id: ${currentTrack.id}');
    debugPrint(
      '[UploadSessionsNotifier] uploadedTrack id: ${uploadedTrack?.id}',
    );
    debugPrint('[UploadSessionsNotifier] uploadState: $uploadState');

    final source = uploadedTrack ?? currentTrack;

    final nextState = switch (uploadState) {
      TrackUploadState.failed => TrackStatus.failed,
      TrackUploadState.finished => TrackStatus.finished,
      TrackUploadState.uploading ||
      TrackUploadState.processing => TrackStatus.processing,
    };

    debugPrint('[UploadSessionsNotifier] resolved TrackStatus: $nextState');

    return source.copyWith(state: nextState);
  }

  void _removeCompletedSession(String uploadId) {
    debugPrint('[UploadSessionsNotifier] _removeCompletedSession() called');
    debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');

    _cancelSubscription(uploadId);

    final nextState = Map<String, UploadSession>.from(state);
    nextState.remove(uploadId);
    state = nextState;

    _latestStatusByUploadId.remove(uploadId);

    debugPrint('[UploadSessionsNotifier] completed session removed');
    debugPrint(
      '[UploadSessionsNotifier] remaining sessions count: ${state.length}',
    );
  }

  void _cancelSubscription(String uploadId) {
    debugPrint('[UploadSessionsNotifier] _cancelSubscription() called');
    debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');

    final subscription = _subscriptions.remove(uploadId);
    if (subscription == null) {
      debugPrint('[UploadSessionsNotifier] no stream subscription found');
    } else {
      debugPrint('[UploadSessionsNotifier] cancelling stream subscription');
      subscription.cancel();
    }

    final cancelRepositorySubscription = _cancelUploadStatusSubscriptions
        .remove(uploadId);

    if (cancelRepositorySubscription == null) {
      debugPrint(
        '[UploadSessionsNotifier] no repository cancel callback found',
      );
    } else {
      debugPrint('[UploadSessionsNotifier] cancelling repository subscription');
      cancelRepositorySubscription();
    }
  }

  void cancelUploadStatusWatch(String uploadId) {
    debugPrint('[UploadSessionsNotifier] cancelUploadStatusWatch() called');
    debugPrint('[UploadSessionsNotifier] uploadId: $uploadId');

    _cancelSubscription(uploadId);
    _latestStatusByUploadId.remove(uploadId);
  }
}
