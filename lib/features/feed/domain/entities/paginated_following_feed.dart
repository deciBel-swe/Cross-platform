import 'following_feed_item.dart';

class PaginatedFollowingFeed {
  const PaginatedFollowingFeed({
    required this.items,
    required this.pageNumber,
    required this.isLast,
  });

  final List<FollowingFeedItem> items;
  final int pageNumber;
  final bool isLast;
}