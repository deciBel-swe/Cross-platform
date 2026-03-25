import 'comment_user.dart';

class Comment {
  const Comment({
    required this.id,
    required this.user,
    required this.body,
    this.timestampSeconds,
    required this.createdAt,
  });
  final int id;
  final CommentUser user;
  final String body;
  final int? timestampSeconds;
  final DateTime createdAt;
}
