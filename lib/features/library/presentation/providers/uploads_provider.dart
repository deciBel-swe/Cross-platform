import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/track.dart';
import '../../domain/entities/track_status.dart';
import 'track_preview_provider.dart';

final uploadsProvider =
    AsyncNotifierProvider.autoDispose<UploadsNotifier, List<Track>>(
      UploadsNotifier.new,
    );

class UploadsNotifier extends AutoDisposeAsyncNotifier<List<Track>> {
  static List<Track>? _memoryCache;

  Timer? _processingRefreshTimer;
  bool _isRefreshingProcessing = false;

  static const int _pageSize = 20;
  static const int _userId = 1;

  int _currentPage = 0;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  @override
  Future<List<Track>> build() async {
    ref.onDispose(() {
      _processingRefreshTimer?.cancel();
      _processingRefreshTimer = null;
    });

    final cached = _memoryCache;
    if (cached != null && cached.isNotEmpty) {
      _syncProcessingPolling(cached);
      // Show stale data immediately and refresh in background.
      Future<void>(() => refreshAll());
      return cached;
    }

    return _fetchFirstPage();
  }

  Future<List<Track>> _fetchFirstPage() async {
    final repo = ref.read(trackRepositoryProvider);
    final result = await repo.fetchTracks(
      userId: _userId,
      page: 0,
      size: _pageSize,
    );

    final paginated = result.fold(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );

    _currentPage = paginated.pageNumber;
    _isLastPage = paginated.isLast;
    _memoryCache = paginated.content;

    _syncProcessingPolling(paginated.content);

    return paginated.content;
  }

  Future<void> refreshAll() async {
    state = const AsyncLoading<List<Track>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => _fetchFirstPage());

    final tracks = state.valueOrNull;
    if (tracks != null) {
      _syncProcessingPolling(tracks);
    }
  }

  Future<void> loadNextPage() async {
    if (_isLastPage || _isLoadingMore) {
      return;
    }

    final currentTracks = state.valueOrNull ?? _memoryCache ?? const <Track>[];
    if (currentTracks.isEmpty) {
      return;
    }

    _isLoadingMore = true;
    try {
      final repo = ref.read(trackRepositoryProvider);
      final nextPage = _currentPage + 1;
      final result = await repo.fetchTracks(
        userId: _userId,
        page: nextPage,
        size: _pageSize,
      );

      final paginated = result.fold(
        (failure) => throw Exception(failure.message),
        (value) => value,
      );

      _currentPage = paginated.pageNumber;
      _isLastPage = paginated.isLast;

      final updated = <Track>[...currentTracks, ...paginated.content];
      _memoryCache = updated;
      state = AsyncData(updated);

      _syncProcessingPolling(updated);
    } catch (_) {
      // Keep existing data on load-more failures.
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refreshTrack(int trackId) async {
    final repo = ref.read(trackRepositoryProvider);
    final result = await repo.fetchTrackById(trackId);
    result.fold((l) => null, (track) {
      final currentTracks = state.valueOrNull ?? [];
      if (currentTracks.isEmpty) return; // Don't update if list not loaded

      final updated = [
        for (final t in currentTracks)
          if (t.id == trackId) track else t,
      ];
      // Only assign state if not disposed
      state = AsyncData(updated);
      _memoryCache = updated;

      _syncProcessingPolling(updated);
    });
  }

  void _syncProcessingPolling(List<Track> tracks) {
    final hasProcessing = tracks.any((t) => t.state == TrackStatus.processing);
    if (!hasProcessing) {
      _processingRefreshTimer?.cancel();
      _processingRefreshTimer = null;
      return;
    }

    if (_processingRefreshTimer != null && _processingRefreshTimer!.isActive) {
      return;
    }

    _processingRefreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _refreshProcessingTracks();
    });
  }

  Future<void> _refreshProcessingTracks() async {
    if (_isRefreshingProcessing) {
      return;
    }

    final tracks = state.valueOrNull ?? _memoryCache ?? const <Track>[];
    if (tracks.isEmpty) {
      return;
    }

    final processingIds = tracks
        .where((t) => t.state == TrackStatus.processing)
        .map((t) => t.id)
        .toList();

    if (processingIds.isEmpty) {
      _syncProcessingPolling(tracks);
      return;
    }

    _isRefreshingProcessing = true;
    try {
      for (final id in processingIds) {
        await refreshTrack(id);
      }
    } finally {
      _isRefreshingProcessing = false;
    }
  }
}
