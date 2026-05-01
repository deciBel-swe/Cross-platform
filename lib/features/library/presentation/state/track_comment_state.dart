import '../../domain/entities/comment.dart';
import '../../domain/entities/paginated_comment_reply.dart';

enum CommentSortOption { newest, oldest, trackTime }

class TrackCommentsState {
  static const Object _unset = Object();

  const TrackCommentsState({
    this.comments = const [],
    this.selectedTimestampSeconds,
    this.isSubmitting = false,
    this.isLoadingComments = false,
    this.loadingReplyIds = const {},
    this.repliesByCommentId = const {},
    this.expandedCommentIds = const {},
    this.deletingCommentId,
    this.sortOption = CommentSortOption.newest,
    this.currentCommentsPage = 0,
    this.isLastCommentsPage = false,
    this.activeReplyCommentId,
    this.replyPrefillText,
  });

  final List<Comment> comments;
  final int? selectedTimestampSeconds;
  final bool isSubmitting;
  final bool isLoadingComments;
  final Set<int> loadingReplyIds;
  final Map<int, PaginatedReplies> repliesByCommentId;
  final Set<int> expandedCommentIds;
  final int? deletingCommentId;
  final CommentSortOption sortOption;
  final int currentCommentsPage;
  final bool isLastCommentsPage;
  final int? activeReplyCommentId;
  final String? replyPrefillText;

  TrackCommentsState copyWith({
    List<Comment>? comments,
    Object? selectedTimestampSeconds = _unset,
    bool? isSubmitting,
    bool? isLoadingComments,
    Set<int>? loadingReplyIds,
    Map<int, PaginatedReplies>? repliesByCommentId,
    Set<int>? expandedCommentIds,
    Object? deletingCommentId = _unset,
    CommentSortOption? sortOption,
    int? currentCommentsPage,
    bool? isLastCommentsPage,
    Object? activeReplyCommentId = _unset,
  }) {
    return TrackCommentsState(
      comments: comments ?? this.comments,
      selectedTimestampSeconds: identical(selectedTimestampSeconds, _unset)
          ? this.selectedTimestampSeconds
          : selectedTimestampSeconds as int?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      loadingReplyIds: loadingReplyIds ?? this.loadingReplyIds,
      repliesByCommentId: repliesByCommentId ?? this.repliesByCommentId,
      expandedCommentIds: expandedCommentIds ?? this.expandedCommentIds,
      deletingCommentId: identical(deletingCommentId, _unset)
          ? this.deletingCommentId
          : deletingCommentId as int?,
      sortOption: sortOption ?? this.sortOption,
      currentCommentsPage: currentCommentsPage ?? this.currentCommentsPage,
      isLastCommentsPage: isLastCommentsPage ?? this.isLastCommentsPage,
      activeReplyCommentId: identical(activeReplyCommentId, _unset)
          ? this.activeReplyCommentId
          : activeReplyCommentId as int?,
    );
  }
}
