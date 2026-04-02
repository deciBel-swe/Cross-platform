import '../../domain/entities/following_feed_item.dart';
import '../../domain/entities/paginated_following_feed.dart';
import '../../domain/repositories/following_feed_repository.dart';

class FollowingFeedMockRepository implements FollowingFeedRepository {
  final List<FollowingFeedItem> _allItems = List<FollowingFeedItem>.generate(
    35,
    (index) {
      final users = ['SUNDER', 'Alis', 'Nova', 'Zayn', 'Luna'];
      final tracks = [
        'It_is_realme.mp3',
        'without a trace',
        'Midnight Drive',
        'Echoes',
        'Lost Signal',
      ];

      final user = users[index % users.length];
      final track = tracks[index % tracks.length];
      final isRepost = index % 3 == 0;

      return FollowingFeedItem(
        userName: user,
        action: isRepost ? 'reposted a track' : 'posted a track',
        trackTitle: track,
        trackArtist: user,
        timeAgo: '${index + 1} hours ago',
        genre: 'Hip Hop',
        likes: '${120 + index * 3}',
        reposts: '${30 + index}',
        plays: '${1500 + index * 50}',
        comments: '${10 + index}',
        duration: '1:${20 + (index % 40)}',
        waveformPeaks: List<double>.generate(100, (i) {
          return ((i + index) % 10) / 10;
        }),
      );
    },
  );

  @override
  Future<PaginatedFollowingFeed> getFollowingFeed({
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final start = page * size;
    if (start >= _allItems.length) {
      return PaginatedFollowingFeed(
        items: const <FollowingFeedItem>[],
        pageNumber: page,
        isLast: true,
      );
    }

    final end = (start + size).clamp(0, _allItems.length);
    final items = _allItems.sublist(start, end);

    return PaginatedFollowingFeed(
      items: items,
      pageNumber: page,
      isLast: end >= _allItems.length,
    );
  }
}