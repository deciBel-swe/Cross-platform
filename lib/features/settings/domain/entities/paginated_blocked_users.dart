import 'blocked_user.dart';

class PaginatedBlockedUsers {
  const PaginatedBlockedUsers({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<BlockedUser> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}