import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../data/repositories/following_feed_mock_repository.dart';
import '../../domain/entities/following_feed_item.dart';
import '../../domain/repositories/following_feed_repository.dart';

import '../../domain/entities/paginated_following_feed.dart';

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
    final result = await _fetchFeed();
    _hasReachedEnd = result.isLast;
    return result.items;
  }

Future<PaginatedFollowingFeed> _fetchFeed() async {
  final repo = ref.read(followingFeedRepositoryProvider);
  return repo.getFollowingFeed(page: _page, size: _pageSize);
}

  Future<void> refresh() async {
    _page = 0;
    _hasReachedEnd = false;
    state = const AsyncLoading();

    final result = await _fetchFeed();
    _hasReachedEnd = result.isLast;
    state = AsyncData(result.items);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _hasReachedEnd) {
      return;
    }

    _isLoadingMore = true;
    _page++;

    try {
      final result = await _fetchFeed();
      _hasReachedEnd = result.isLast;

      final current = state.value ?? <FollowingFeedItem>[];
      state = AsyncData([...current, ...result.items]);
    } catch (_) {
      _page--;
      rethrow;
    } finally {
      _isLoadingMore = false;
    }
  }
}