/// A generic entity for paginated responses.
class PaginatedData<T> {
  const PaginatedData({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<T> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}
