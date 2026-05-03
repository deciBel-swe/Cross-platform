import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/feed_track.dart';
import '../providers/feed_repository_provider.dart';

/// [FeedState] holds the accumulated list of feed tracks plus pagination info.
class FeedState {
  const FeedState({
    required this.tracks,
    required this.currentPage,
    required this.isLast,
    required this.isLoadingMore,
  });

  final List<FeedTrack> tracks;
  final int currentPage;
  final bool isLast;
  final bool isLoadingMore;

  FeedState copyWith({
    List<FeedTrack>? tracks,
    int? currentPage,
    bool? isLast,
    bool? isLoadingMore,
  }) {
    return FeedState(
      tracks: tracks ?? this.tracks,
      currentPage: currentPage ?? this.currentPage,
      isLast: isLast ?? this.isLast,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Async notifier that loads the first page on init and supports
/// loading subsequent pages via [loadMore].
class FeedNotifier extends AsyncNotifier<FeedState> {
  static const int _pageSize = 20;

  @override
  Future<FeedState> build() async {
    return _fetchPage(0);
  }

  /// Loads the next page, wrapping back to page 0 after the last page.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextPage = current.isLast ? 0 : current.currentPage + 1;
    try {
      final next = await _fetchPage(nextPage, existing: current.tracks);
      state = AsyncData(next);
    } catch (e, st) {
      // Revert loading flag but keep existing data.
      state = AsyncData(current.copyWith(isLoadingMore: false));
      // Optionally surface the error:
      // ignore: unused_local_variable
      final _ = (e, st);
    }
  }

  /// Refreshes from page 0.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(0));
  }

  Future<FeedState> _fetchPage(int page, {List<FeedTrack>? existing}) async {
    final repo = ref.read(feedRepositoryProvider);
    final result = await repo.getFeed(page: page, size: _pageSize);

    return result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          return FeedState(
            tracks: existing ?? const [],
            currentPage: page == 0 ? 0 : page - 1,
            isLast: true,
            isLoadingMore: false,
          );
        }
        throw Exception(failure.message);
      },
      (paginated) {
        return FeedState(
          tracks: [...?existing, ...paginated.content],
          currentPage: paginated.pageNumber,
          isLast: paginated.isLast,
          isLoadingMore: false,
        );
      },
    );
  }
}

/// Top-level provider for the feed screen.
final feedProvider = AsyncNotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);
