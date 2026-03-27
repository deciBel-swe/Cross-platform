import '../../domain/entities/following_feed_item.dart';
import '../../domain/repositories/following_feed_repository.dart';

class FollowingFeedMockRepository implements FollowingFeedRepository {
  @override
  
  Future<List<FollowingFeedItem>> getFollowingFeed({
    int page = 0,
    int size = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final users = [
      'SUNDER',
      'Alis',
      'Nova',
      'Zayn',
      'Luna',
    ];

    final tracks = [
      'It_is_realme.mp3',
      'without a trace',
      'Midnight Drive',
      'Echoes',
      'Lost Signal',
    ];

    return List.generate(10, (index) {
      final user = users[index % users.length];
      final track = tracks[index % tracks.length];

      final isRepost = index % 3 == 0;

      return FollowingFeedItem(
        userName: user,
        action: isRepost ? 'reposted a track' : 'posted a track',
        trackTitle:  track,
        trackArtist: user,
        timeAgo: '${index + 1} hours ago',
        genre: 'Hip Hop',
        likes: '${120 + index * 3}',
        reposts: '${30 + index}',
        plays: '${1500 + index * 50}',
        comments: '${10 + index}',
        duration: '1:${20 + index}',
        waveformPeaks: List.generate(100, (i) {
          return ((i + index) % 10) / 10;
        }),
      );
    });
  }
}