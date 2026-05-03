import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/feed_track.dart';
import '../providers/feed_repository_provider.dart';
import 'feed_notifier.dart';

/// Async notifier for the "Discover" feed (artist station).
class DiscoverFeedNotifier extends AsyncNotifier<FeedState> {
  static const int _pageSize = 20;

  @override
  Future<FeedState> build() async {
    return _fetchPage(0);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextPage = current.isLast ? 0 : current.currentPage + 1;
    try {
      final next = await _fetchPage(nextPage, existing: current.tracks);
      state = AsyncData(next);
    } catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(0));
  }

  Future<FeedState> _fetchPage(int page, {List<FeedTrack>? existing}) async {
    final repo = ref.read(feedRepositoryProvider);

    final result = await repo.getDiscoverFeed(page: page, size: _pageSize);

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

final discoverFeedProvider =
    AsyncNotifierProvider<DiscoverFeedNotifier, FeedState>(
      DiscoverFeedNotifier.new,
    );
