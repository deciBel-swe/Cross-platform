class PostCommentRequest {
  final String body;
  final int? timestampSeconds;

  const PostCommentRequest({required this.body, this.timestampSeconds});
}
