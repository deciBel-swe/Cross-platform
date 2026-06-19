import '../../../library/domain/entities/track.dart';

/// Paginated listening-history tracks returned by `/users/me/history`.
class ListeningHistoryPage {
  const ListeningHistoryPage({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<Track> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}
