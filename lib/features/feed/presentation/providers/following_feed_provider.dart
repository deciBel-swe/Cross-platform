import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../data/repositories/following_feed_mock_repository.dart';
import '../../domain/entities/following_feed_item.dart';
import '../../domain/repositories/following_feed_repository.dart';

final followingFeedRepositoryProvider =
    Provider<FollowingFeedRepository>((ref) {
  final useMock = dotenv.env['USE_MOCK_SERVICES']?.toLowerCase() == 'true';

  if (useMock) {
    return FollowingFeedMockRepository();
  }

  return getIt<FollowingFeedRepository>();
});

final followingFeedProvider =
    AsyncNotifierProvider<FollowingFeedNotifier, List<FollowingFeedItem>>(
  FollowingFeedNotifier.new,
);

class FollowingFeedNotifier extends AsyncNotifier<List<FollowingFeedItem>> {
  int _page = 0;
  bool _isLoadingMore = false;
  bool _hasReachedEnd = false;
  static const int _pageSize = 20;

  @override
  Future<List<FollowingFeedItem>> build() async {
    return _fetchFeed();
  }

  Future<List<FollowingFeedItem>> _fetchFeed() async {
    final repo = ref.read(followingFeedRepositoryProvider);
    return repo.getFollowingFeed(page: _page, size: _pageSize);
  }

  Future<void> refresh() async {
    _page = 0;
    _hasReachedEnd = false;
    state = const AsyncLoading();
    final data = await _fetchFeed();
    state = AsyncData(data);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _hasReachedEnd) {
      return;
    }

    _isLoadingMore = true;
    _page++;

    final repo = ref.read(followingFeedRepositoryProvider);
    final newItems = await repo.getFollowingFeed(page: _page, size: _pageSize);

    if (newItems.isEmpty) {
      _hasReachedEnd = true;
    }

    final current = state.value ?? <FollowingFeedItem>[];
    state = AsyncData([...current, ...newItems]);

    _isLoadingMore = false;
  }
}