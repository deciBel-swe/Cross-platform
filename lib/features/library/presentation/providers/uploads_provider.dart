import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/track_status.dart';
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

  int? _activeUserId;

  bool _isDisposed = false;

  Timer? _processingRefreshTimer;
  bool _isRefreshingProcessing = false;

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
    final result = await repo.fetchTracks(
      userId: userId,
      page: 0,
      size: _pageSize,
    );

    final paginated = result.fold(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );

    _currentPage = paginated.pageNumber;
    _isLastPage = paginated.isLast;
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
      final result = await repo.fetchTracks(
        userId: userId,
        page: nextPage,
        size: _pageSize,
      );

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

  Future<void> refreshTrack(int trackId) async {
    if (_isDisposed) return;
    final repo = ref.read(trackRepositoryProvider);
    final result = await repo.fetchTrackById(trackId);

    if (_isDisposed) return;
    result.fold((l) => null, (track) {
      if (_isDisposed) return;
      final currentTracks = state.valueOrNull ?? [];
      if (currentTracks.isEmpty) return; // Don't update if list not loaded

      final updated = [
        for (final t in currentTracks)
          if (t.id == trackId) track else t,
      ];
      if (_isDisposed) return;
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
        if (_isDisposed) return;
      }
    } finally {
      _isRefreshingProcessing = false;
    }
  }
}
