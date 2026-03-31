import '../../domain/entities/comment.dart';
import '../../domain/entities/comment_reply.dart';

class TrackCommentsState {
  const TrackCommentsState({
    this.comments = const [],
    this.selectedTimestampSeconds,
    this.isSubmitting = false,

    this.isLoadingComments = false,
    this.isLoadingReplies = false,
    this.repliesByCommentId = const {},
    this.expandedCommentIds = const {},
    this.deletingCommentId,
  });

  final List<Comment> comments;
  final int? selectedTimestampSeconds;
  final bool isSubmitting;

  final bool isLoadingComments;
  final bool isLoadingReplies;
  final Map<int, List<CommentReply>> repliesByCommentId;
  final Set<int> expandedCommentIds;
  final int? deletingCommentId;

  TrackCommentsState copyWith({
    List<Comment>? comments,
    int? selectedTimestampSeconds,
    bool? isSubmitting,

    bool? isLoadingComments,
    bool? isLoadingReplies,
    Map<int, List<CommentReply>>? repliesByCommentId,
    Set<int>? expandedCommentIds,
    int? deletingCommentId,
  }) {
    return TrackCommentsState(
      comments: comments ?? this.comments,
      selectedTimestampSeconds:
          selectedTimestampSeconds ?? this.selectedTimestampSeconds,
      isSubmitting: isSubmitting ?? this.isSubmitting,

      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingReplies: isLoadingReplies ?? this.isLoadingReplies,
      repliesByCommentId: repliesByCommentId ?? this.repliesByCommentId,
      expandedCommentIds: expandedCommentIds ?? this.expandedCommentIds,
      deletingCommentId: deletingCommentId ?? this.deletingCommentId,
    );
  }
}
