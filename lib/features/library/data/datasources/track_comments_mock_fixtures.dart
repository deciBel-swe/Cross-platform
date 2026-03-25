import '../models/comment_user_model.dart';
import '../models/post_comment_response_model.dart';

const CommentUserModel mockCommentUser = CommentUserModel(
  id: 1,
  username: 'tarek',
  avatarUrl: 'http://example.com/avatar.jpg',
);

final PostCommentResponseModel mockPostedComment = PostCommentResponseModel(
  commentId: 101,
  user: mockCommentUser,
  body: 'This part is fire 🔥',
  timestampSeconds: 17,
  createdAt: DateTime.parse('2026-03-25T14:15:22.123Z'),
);

final List<PostCommentResponseModel> mockTrackComments = [
  PostCommentResponseModel(
    commentId: 101,
    user: mockCommentUser,
    body: 'This part is fire 🔥',
    timestampSeconds: 17,
    createdAt: DateTime.parse('2026-03-25T14:15:22.123Z'),
  ),
  PostCommentResponseModel(
    commentId: 102,
    user: const CommentUserModel(
      id: 2,
      username: 'sarah',
      avatarUrl: 'http://example.com/avatar2.jpg',
    ),
    body: 'Love this transition',
    timestampSeconds: 29,
    createdAt: DateTime.parse('2026-03-25T14:16:10.000Z'),
  ),
  PostCommentResponseModel(
    commentId: 103,
    user: const CommentUserModel(
      id: 3,
      username: 'hasna',
      avatarUrl: 'http://example.com/avatar3.jpg',
    ),
    body: 'Crazy drop here',
    timestampSeconds: 17,
    createdAt: DateTime.parse('2026-03-25T14:16:45.000Z'),
  ),
  PostCommentResponseModel(
    commentId: 104,
    user: const CommentUserModel(
      id: 4,
      username: 'dissolve',
      avatarUrl: 'http://example.com/avatar4.jpg',
    ),
    body: 'Replaying this part again',
    timestampSeconds: 17,
    createdAt: DateTime.parse('2026-03-25T14:17:05.000Z'),
  ),
];
