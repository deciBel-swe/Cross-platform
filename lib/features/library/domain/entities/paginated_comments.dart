import 'comment.dart';

class PaginatedComments {
  const PaginatedComments({
    this.content = const [],
    this.pageNumber,
    this.pageSize,
    this.totalElements,
    this.totalPages,
    this.isLast,
  });

  final List<Comment> content;
  final int? pageNumber;
  final int? pageSize;
  final int? totalElements;
  final int? totalPages;
  final bool? isLast;
}
