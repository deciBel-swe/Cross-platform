import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/listening_history_page.dart';
import '../../domain/repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => getIt<HistoryRepository>(),
);

final historyProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<HistoryState>>(
      (ref) => HistoryNotifier(ref.watch(historyRepositoryProvider)),
    );

const int _defaultHistoryPageSize = 20;

/// UI state for the current user's paginated listening history.
class HistoryState {
  const HistoryState({
    required this.tracks,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
    this.isLoadingMore = false,
  });

  factory HistoryState.fromPage(ListeningHistoryPage page) {
    return HistoryState(
      tracks: page.content,
      pageNumber: page.pageNumber,
      pageSize: page.pageSize > 0 ? page.pageSize : _defaultHistoryPageSize,
      totalElements: page.totalElements,
      totalPages: page.totalPages,
      isLast: page.isLast,
    );
  }

  factory HistoryState.empty({int pageSize = _defaultHistoryPageSize}) {
    return HistoryState(
      tracks: const <Track>[],
      pageNumber: 0,
      pageSize: pageSize,
      totalElements: 0,
      totalPages: 0,
      isLast: true,
    );
  }

  final List<Track> tracks;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
  final bool isLoadingMore;

  HistoryState copyWith({
    List<Track>? tracks,
    int? pageNumber,
    int? pageSize,
    int? totalElements,
    int? totalPages,
    bool? isLast,
    bool? isLoadingMore,
  }) {
    return HistoryState(
      tracks: tracks ?? this.tracks,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalElements: totalElements ?? this.totalElements,
      totalPages: totalPages ?? this.totalPages,
      isLast: isLast ?? this.isLast,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Loads, refreshes, and locally updates the user's listening history.
class HistoryNotifier extends StateNotifier<AsyncValue<HistoryState>> {
  HistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  static const int defaultPageSize = _defaultHistoryPageSize;

  final HistoryRepository _repository;
  bool _isFetching = false;
  bool _isLoadingMore = false;

  Future<void> fetchHistory() async {
    if (_isFetching) {
      return;
    }

    _isFetching = true;
    state = const AsyncValue.loading();

    final result = await _repository.getListeningHistory(
      page: 0,
      size: defaultPageSize,
    );

    if (!mounted) {
      _isFetching = false;
      return;
    }

    state = result.fold(
      (failure) =>
          AsyncValue<HistoryState>.error(failure.message, StackTrace.current),
      (page) => AsyncValue<HistoryState>.data(HistoryState.fromPage(page)),
    );
    _isFetching = false;
  }

  Future<void> refresh() => fetchHistory();

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.isLast ||
        current.isLoadingMore ||
        _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;
    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    final result = await _repository.getListeningHistory(
      page: current.pageNumber + 1,
      size: current.pageSize,
    );

    if (!mounted) {
      _isLoadingMore = false;
      return;
    }

    state = result.fold(
      (_) =>
          AsyncValue<HistoryState>.data(current.copyWith(isLoadingMore: false)),
      (page) => AsyncValue<HistoryState>.data(
        HistoryState.fromPage(page).copyWith(
          tracks: <Track>[...current.tracks, ...page.content],
          isLoadingMore: false,
        ),
      ),
    );
    _isLoadingMore = false;
  }

  void addLocalRecentlyPlayed(Track track) {
    final current = state.valueOrNull ?? HistoryState.empty();
    final updatedTracks = <Track>[
      track,
      ...current.tracks.where((item) => item.id != track.id),
    ];

    state = AsyncValue.data(
      current.copyWith(
        tracks: updatedTracks,
        totalElements: updatedTracks.length > current.totalElements
            ? updatedTracks.length
            : current.totalElements,
      ),
    );
  }
}
