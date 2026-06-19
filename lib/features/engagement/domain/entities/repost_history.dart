enum RepostHistoryItemType { track, playlist }

class RepostHistoryItem {
  const RepostHistoryItem({
    required this.type,
    required this.id,
    required this.title,
    this.coverUrl,
  });

  final RepostHistoryItemType type;
  final int id;
  final String title;
  final String? coverUrl;

  bool get isTrack => type == RepostHistoryItemType.track;
  bool get isPlaylist => type == RepostHistoryItemType.playlist;
}

class PaginatedRepostHistory {
  const PaginatedRepostHistory({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<RepostHistoryItem> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}
