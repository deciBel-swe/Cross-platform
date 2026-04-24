import 'discovery_track.dart';

/// Paginated discovery tracks response shared by trending and stations.
class PaginatedDiscoveryTracks {
  const PaginatedDiscoveryTracks({
    required this.content,
    this.pageNumber = 0,
    this.pageSize = 0,
    this.totalElements = 0,
    this.totalPages = 0,
    this.isLast = true,
  });

  final List<DiscoveryTrack> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}
