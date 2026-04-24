import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/feed_repository_provider.dart';
import 'feed_notifier.dart';

/// Async notifier for the "Discover" feed (artist station).
/// Uses the current user's ID as the artistId for discovery.
class DiscoverFeedNotifier extends AsyncNotifier<FeedState> {
  static const int _pageSize = 20;

  @override
  Future<FeedState> build() async {
    return _fetchPage(0);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.isLast || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextPage = current.currentPage + 1;
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

  Future<FeedState> _fetchPage(int page, {List<dynamic>? existing}) async {
    final repo = ref.read(feedRepositoryProvider);
    final auth = ref.read(authStateProvider);

    int artistId = 0;
    if (auth is AsyncData<AuthState> && auth.value is AuthAuthenticated) {
      artistId = (auth.value as AuthAuthenticated).user.id;
    }

    final result = await repo.getDiscoverFeed(
      artistId: artistId,
      page: page,
      size: _pageSize,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (paginated) => FeedState(
        tracks: [...?existing, ...paginated.content],
        currentPage: paginated.pageNumber,
        isLast: paginated.isLast,
        isLoadingMore: false,
      ),
    );
  }
}

final discoverFeedProvider = AsyncNotifierProvider<DiscoverFeedNotifier, FeedState>(
  DiscoverFeedNotifier.new,
);
