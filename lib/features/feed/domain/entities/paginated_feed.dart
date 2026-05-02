import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_track.dart';

part 'paginated_feed.freezed.dart';

/// Domain entity representing a paginated response from the `/feed` endpoint.
@freezed
class PaginatedFeed with _$PaginatedFeed {
  const factory PaginatedFeed({
    required List<FeedTrack> content,
    required int pageNumber,
    required int pageSize,
    required int totalElements,
    required int totalPages,
    required bool isLast,
  }) = _PaginatedFeed;
}
