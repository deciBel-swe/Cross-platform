import 'comment_reply.dart';

class PaginatedReplies {
  const PaginatedReplies({
    this.content = const [],
    this.pageNumber,
    this.pageSize,
    this.totalElements,
    this.totalPages,
    this.isLast,
  });

  final List<CommentReply> content;
  final int? pageNumber;
  final int? pageSize;
  final int? totalElements;
  final int? totalPages;
  final bool? isLast;
}
