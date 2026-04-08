import 'track_engager.dart';

/// Paginated response wrapper for track engagers (likers / reposters).
class PaginatedEngagers {
  const PaginatedEngagers({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<TrackEngager> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}
