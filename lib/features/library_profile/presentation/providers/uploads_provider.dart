import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';
import 'track_repository_provider.dart';

final uploadsProvider =
    AsyncNotifierProvider.autoDispose<UploadsNotifier, List<Track>>(
      UploadsNotifier.new,
    );

class UploadsNotifier extends AutoDisposeAsyncNotifier<List<Track>> {
  static final Map<
    int,
    ({List<Track> tracks, int currentPage, bool isLastPage})
  >
  _memoryCacheByUser = {};

  @visibleForTesting
  static void clearMemoryCache() {
    _memoryCacheByUser.clear();
  }

  int? _activeUserId;

  bool _isDisposed = false;

  Timer? _processingRefreshTimer;
  bool _isRefreshingProcessing = false;
  // Tracks that reached terminal statuses so we stop polling them.
  final Set<int> _terminalStatusTrackIds = <int>{};

  static const int _pageSize = 20;

  int _currentPage = 0;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  @override
  Future<List<Track>> build() async {
    ref.onDispose(() {
      _isDisposed = true;
      _processingRefreshTimer?.cancel();
      _processingRefreshTimer = null;
    });

    final userId = _resolveCurrentUserId();
    _activeUserId = userId;

    if (userId == null) {
      _currentPage = 0;
      _isLastPage = true;
      _syncProcessingPolling(const <Track>[]);
      return const <Track>[];
    }

    final cached = _memoryCacheByUser[userId];
    if (cached != null && cached.tracks.isNotEmpty) {
      _currentPage = cached.currentPage;
      _isLastPage = cached.isLastPage;

      _syncProcessingPolling(cached.tracks);
      Future<void>(() async {
        if (_isDisposed) return;
        await refreshAll();
      });
      return cached.tracks;
    }

    return _fetchFirstPage();
  }

  int? _resolveCurrentUserId() {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.maybeWhen(
      data: (state) {
        if (state is AuthAuthenticated) {
          return state.user.id;
        }
        return null;
      },
      orElse: () => null,
    );
  }

  Future<List<Track>> _fetchFirstPage() async {
    final userId = _activeUserId;
    if (userId == null) {
      _currentPage = 0;
      _isLastPage = true;
      return const <Track>[];
    }

    final repo = ref.read(trackRepositoryProvider);
    final result = await repo.fetchMyTracks(page: 0, size: _pageSize);

    final paginated = result.fold(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );

    _currentPage = paginated.pageNumber;
    _isLastPage = paginated.isLast;
    _terminalStatusTrackIds.clear();
    _memoryCacheByUser[userId] = (
      tracks: paginated.content,
      currentPage: paginated.pageNumber,
      isLastPage: paginated.isLast,
    );

    _syncProcessingPolling(paginated.content);

    return paginated.content;
  }

  Future<void> refreshAll() async {
    if (_isDisposed) return;
    state = const AsyncLoading<List<Track>>().copyWithPrevious(state);
    final nextState = await AsyncValue.guard(() => _fetchFirstPage());
    if (_isDisposed) return;
    state = nextState;

    final tracks = state.valueOrNull;
    if (tracks != null) {
      _syncProcessingPolling(tracks);
    }
  }

  Future<void> loadNextPage() async {
    if (_isDisposed) return;
    if (_isLastPage || _isLoadingMore) {
      return;
    }

    final userId = _activeUserId;
    if (userId == null) {
      return;
    }

    final currentTracks =
        state.valueOrNull ??
        _memoryCacheByUser[userId]?.tracks ??
        const <Track>[];
    if (currentTracks.isEmpty) {
      return;
    }

    _isLoadingMore = true;
    try {
      final repo = ref.read(trackRepositoryProvider);
      final nextPage = _currentPage + 1;
      final result = await repo.fetchMyTracks(page: nextPage, size: _pageSize);

      if (_isDisposed) return;

      final paginated = result.fold(
        (failure) => throw Exception(failure.message),
        (value) => value,
      );

      _currentPage = paginated.pageNumber;
      _isLastPage = paginated.isLast;

      final updated = <Track>[...currentTracks, ...paginated.content];
      _memoryCacheByUser[userId] = (
        tracks: updated,
        currentPage: paginated.pageNumber,
        isLastPage: paginated.isLast,
      );
      if (_isDisposed) return;
      state = AsyncData(updated);

      _syncProcessingPolling(updated);
    } catch (_) {
      // Keep existing data on load-more failures.
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<bool> refreshTrack(int trackId) async {
    if (_isDisposed) return false;
    final repo = ref.read(trackRepositoryProvider);
    final userId = _activeUserId;
    if (userId == null) {
      return false;
    }

    final result = await repo.fetchMyTracks(page: 0, size: _pageSize);

    if (_isDisposed) return false;
    var didUpdate = false;
    result.fold((l) => null, (paginated) {
      final Track? track = paginated.content
          .where((item) => item.id == trackId)
          .cast<Track?>()
          .firstWhere((item) => item != null, orElse: () => null);

      if (track == null) {
        return;
      }

      if (_isDisposed) return;
      final currentTracks = state.valueOrNull ?? [];
      if (currentTracks.isEmpty) return; // Don't update if list not loaded

      if (track.state == TrackStatus.processing) {
        // Track became non-terminal again, so it should be polled.
        _terminalStatusTrackIds.remove(track.id);
      } else {
        // Finished/failed items are treated as terminal and excluded from polling.
        _terminalStatusTrackIds.add(track.id);
      }

      final updated = [
        for (final t in currentTracks)
          if (t.id == trackId) track else t,
      ];
      if (_isDisposed) return;
      state = AsyncData(updated);
      didUpdate = true;

      final userId = _activeUserId;
      if (userId != null) {
        final cached = _memoryCacheByUser[userId];
        _memoryCacheByUser[userId] = (
          tracks: updated,
          currentPage: cached?.currentPage ?? _currentPage,
          isLastPage: cached?.isLastPage ?? _isLastPage,
        );
      }

      _syncProcessingPolling(updated);
    });

    return didUpdate;
  }

  Future<bool> deleteTrack(int trackId) async {
    if (_isDisposed) return false;

    final repo = ref.read(trackRepositoryProvider);
    try {
      final result = await repo
          .deleteTrack(trackId)
          .timeout(const Duration(seconds: 12));

      if (_isDisposed) return false;

      return result.fold((_) => false, (_) {
        _removeTrackLocally(trackId);
        return true;
      });
    } on TimeoutException {
      return false;
    }
  }

  void _removeTrackLocally(int trackId) {
    if (_isDisposed) return;

    _terminalStatusTrackIds.remove(trackId);

    final currentTracks = state.valueOrNull;
    if (currentTracks != null) {
      final updated = currentTracks
          .where((track) => track.id != trackId)
          .toList(growable: false);

      if (updated.length != currentTracks.length) {
        state = AsyncData(updated);
      }
    }

    final userId = _activeUserId;
    if (userId != null) {
      _removeTrackFromCache(userId: userId, trackId: trackId);
    } else {
      for (final cachedUserId in _memoryCacheByUser.keys.toList()) {
        _removeTrackFromCache(userId: cachedUserId, trackId: trackId);
      }
    }

    _syncProcessingPolling(state.valueOrNull ?? const <Track>[]);
  }

  static void _removeTrackFromCache({
    required int userId,
    required int trackId,
  }) {
    final cached = _memoryCacheByUser[userId];
    if (cached == null) {
      return;
    }

    final updated = cached.tracks
        .where((track) => track.id != trackId)
        .toList(growable: false);
    if (updated.length == cached.tracks.length) {
      return;
    }

    _memoryCacheByUser[userId] = (
      tracks: updated,
      currentPage: cached.currentPage,
      isLastPage: cached.isLastPage,
    );
  }

  void _setLocalTrackState(int trackId, TrackStatus stateValue) {
    if (_isDisposed) return;

    final currentTracks = state.valueOrNull ?? const <Track>[];
    if (currentTracks.isEmpty) return;

    var didChange = false;
    final updated = [
      for (final track in currentTracks)
        if (track.id == trackId)
          if (track.state == stateValue)
            track
          else
            Track(
              id: track.id,
              title: track.title,
              artist: track.artist,
              trackUrl: track.trackUrl,
              coverUrl: track.coverUrl,
              waveformUrl: track.waveformUrl,
              genre: track.genre,
              tags: track.tags,
              state: stateValue,
              releaseDate: track.releaseDate,
              playCount: track.playCount,
              likeCount: track.likeCount,
              repostCount: track.repostCount,
              isLiked: track.isLiked,
              isReposted: track.isReposted,
              createdAt: track.createdAt,
            )
        else
          track,
    ];

    for (var i = 0; i < currentTracks.length; i++) {
      if (!identical(currentTracks[i], updated[i])) {
        didChange = true;
        break;
      }
    }

    if (!didChange) return;

    state = AsyncData(updated);

    final userId = _activeUserId;
    if (userId != null) {
      final cached = _memoryCacheByUser[userId];
      _memoryCacheByUser[userId] = (
        tracks: updated,
        currentPage: cached?.currentPage ?? _currentPage,
        isLastPage: cached?.isLastPage ?? _isLastPage,
      );
    }

    _syncProcessingPolling(updated);
  }

  void _syncProcessingPolling(List<Track> tracks) {
    // Poll only tracks still processing and not already marked terminal.
    final hasProcessing = tracks.any(
      (t) =>
          t.state == TrackStatus.processing &&
          !_terminalStatusTrackIds.contains(t.id),
    );
    if (!hasProcessing) {
      _processingRefreshTimer?.cancel();
      _processingRefreshTimer = null;
      return;
    }

    if (_processingRefreshTimer != null && _processingRefreshTimer!.isActive) {
      return;
    }

    _processingRefreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _refreshProcessingTracks();
    });
  }

  Future<void> _refreshProcessingTracks() async {
    if (_isDisposed) return;
    if (_isRefreshingProcessing) {
      return;
    }

    final userId = _activeUserId;
    final tracks =
        state.valueOrNull ??
        (userId == null ? null : _memoryCacheByUser[userId]?.tracks) ??
        const <Track>[];
    if (tracks.isEmpty) {
      return;
    }

    final processingIds = tracks
        .where(
          (t) =>
              t.state == TrackStatus.processing &&
              !_terminalStatusTrackIds.contains(t.id),
        )
        .map((t) => t.id)
        .toList();

    if (processingIds.isEmpty) {
      _syncProcessingPolling(tracks);
      return;
    }

    _isRefreshingProcessing = true;
    try {
      final repo = ref.read(trackRepositoryProvider);
      for (final id in processingIds) {
        // Source of truth: backend processing status endpoint.
        final statusResult = await repo.fetchTrackStatusById(id);
        if (_isDisposed) return;

        await statusResult.fold(
          (_) async {
            await refreshTrack(id);
          },
          (status) async {
            switch (status) {
              case 'UPLOADING':
              case 'PROCESSING':
                // Keep polling while processing is active.
                _terminalStatusTrackIds.remove(id);
                break;
              case 'FINISHED':
                // Refresh once to pull final waveform URL/state from track list endpoint.
                _terminalStatusTrackIds.add(id);
                final refreshed = await refreshTrack(id);
                if (!refreshed) {
                  _setLocalTrackState(id, TrackStatus.finished);
                }
                break;
              case 'FAILED':
                // Terminal failed status should stop repeated polling.
                _terminalStatusTrackIds.add(id);
                await refreshTrack(id);
                break;
              default:
                await refreshTrack(id);
            }
          },
        );

        if (_isDisposed) return;
      }
    } finally {
      _isRefreshingProcessing = false;
    }
  }

  void addTrack(Track track) {
    if (_isDisposed) return;
    final currentTracks = state.valueOrNull ?? [];

    // Prepend the new track
    final updated = [track, ...currentTracks];

    if (track.state == TrackStatus.processing) {
      _terminalStatusTrackIds.remove(track.id);
    }

    // Update state
    state = AsyncData(updated);

    // Update cache
    final userId = _activeUserId;
    if (userId != null) {
      final cached = _memoryCacheByUser[userId];
      _memoryCacheByUser[userId] = (
        tracks: updated,
        currentPage: cached?.currentPage ?? _currentPage,
        isLastPage: cached?.isLastPage ?? _isLastPage,
      );
    }

    _syncProcessingPolling(updated);
  }

  void invalidateCache() {
    final userId = _activeUserId;
    if (userId != null) {
      _memoryCacheByUser.remove(userId);
    }
  }
}
