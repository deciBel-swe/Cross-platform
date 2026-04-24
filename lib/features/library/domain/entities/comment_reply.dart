import 'comment_user.dart';

class CommentReply {
  const CommentReply({
    required this.commentId,
    required this.user,
    required this.body,
    this.createdAt,
  });
  final int commentId;
  final CommentUser user;
  final String body;
  final DateTime? createdAt;
}
