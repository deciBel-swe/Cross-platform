import '../entities/following_feed_item.dart';

abstract class FollowingFeedRepository {
  Future<List<FollowingFeedItem>> getFollowingFeed({
    int page = 0,
    int size = 20,
  });
}