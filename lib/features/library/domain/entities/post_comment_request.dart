class PostCommentRequest {
  const PostCommentRequest({required this.body, this.timestampSeconds});
  final String body;
  final int? timestampSeconds;
}
