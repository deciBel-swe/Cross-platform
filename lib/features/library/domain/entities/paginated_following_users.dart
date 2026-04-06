import 'following_user.dart';

class PaginatedFollowingUsers {
  const PaginatedFollowingUsers({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<FollowingUser> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}