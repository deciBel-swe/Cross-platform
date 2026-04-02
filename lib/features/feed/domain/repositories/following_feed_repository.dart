import '../entities/paginated_following_feed.dart';

abstract class FollowingFeedRepository {
  Future<PaginatedFollowingFeed> getFollowingFeed({
    int page = 0,
    int size = 20,
  });
}