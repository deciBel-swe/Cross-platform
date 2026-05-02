import 'comment_user.dart';

class Comment {
  const Comment({
    required this.commentid,
    required this.user,
    required this.body,
    this.timestampSeconds,
    required this.createdAt,
    required this.replycount,
    this.replyToCommentId,
  });
  final int commentid;
  final CommentUser user;
  final String body;
  final int? timestampSeconds;
  final DateTime createdAt;

  final int replycount;
  final int? replyToCommentId;
}
