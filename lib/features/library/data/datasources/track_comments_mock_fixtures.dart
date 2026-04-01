import '../models/comment_user_model.dart';
import '../models/post_comment_response_model.dart';

class TrackCommentsMockFixtures {
  TrackCommentsMockFixtures._();

  static const Duration mockDelay = Duration(milliseconds: 800);

  static const CommentUserModel mockCommentUser = CommentUserModel(
    id: 0,
    username: 'mock_user_free',
    avatarUrl: '',
  );

  static final PostCommentResponseModel mockPostedComment =
      PostCommentResponseModel(
        replycount: 1,
        commentId: 101,
        user: mockCommentUser,
        body: 'This part is fire 🔥',
        timestampSeconds: 17,
        createdAt: DateTime.parse('2026-03-25T14:15:22.123Z'),
      );

  static final List<PostCommentResponseModel> mockTrackComments = [
    PostCommentResponseModel(
      replycount: 3,
      commentId: 101,
      user: mockCommentUser,
      body: 'This part is fire 🔥',
      timestampSeconds: 17,
      createdAt: DateTime.parse('2026-03-25T14:15:22.123Z'),
    ),
    PostCommentResponseModel(
      replycount: 2,
      commentId: 102,
      user: const CommentUserModel(id: 2, username: 'sarah', avatarUrl: ''),
      body: 'Love this transition',
      timestampSeconds: 29,
      createdAt: DateTime.parse('2026-03-25T14:16:10.000Z'),
    ),
    PostCommentResponseModel(
      replycount: 3,
      commentId: 103,
      user: const CommentUserModel(id: 3, username: 'hasna', avatarUrl: ''),
      body: 'Crazy drop here',
      timestampSeconds: 17,
      createdAt: DateTime.parse('2026-03-25T14:16:45.000Z'),
    ),
    PostCommentResponseModel(
      replycount: 3,
      commentId: 104,
      user: const CommentUserModel(id: 4, username: 'dissolve', avatarUrl: ''),
      body: 'Replaying this part again',
      timestampSeconds: 17,
      createdAt: DateTime.parse('2026-03-25T14:17:05.000Z'),
    ),
  ];

  static const Map<String, dynamic> mockCommentsResponse = {
    'content': [
      {
        'id': 1,
        'user': {
          'id': 101,
          'username': 'tarek',
          'avatarUrl': 'https://i.pravatar.cc/150?u=tarek',
        },
        'body': 'Great transition here',
        'timestampSeconds': 42,
        'createdAt': '2026-03-31T10:00:00.000Z',
      },
      {
        'id': 2,
        'user': {
          'id': 102,
          'username': 'ziad',
          'avatarUrl': 'https://i.pravatar.cc/150?u=ziad',
        },
        'body': 'Love this drop',
        'timestampSeconds': 75,
        'createdAt': '2026-03-31T10:05:00.000Z',
      },
      {
        'id': 3,
        'user': {
          'id': 103,
          'username': 'mona',
          'avatarUrl': 'https://i.pravatar.cc/150?u=mona',
        },
        'body': 'This part needs a longer build-up',
        'timestampSeconds': 96,
        'createdAt': '2026-03-31T10:10:00.000Z',
      },
    ],
    'pageNumber': 0,
    'pageSize': 20,
    'totalElements': 3,
    'totalPages': 1,
    'isLast': true,
  };

  static const Map<String, dynamic> mockRepliesResponse = {
    'content': [
      {
        'id': 11,
        'user': {
          'id': 104,
          'username': 'sara',
          'avatarUrl': 'https://i.pravatar.cc/150?u=sara',
        },
        'body': 'Totally agree',
        'createdAt': '2026-03-31T10:12:00.000Z',
      },
      {
        'id': 12,
        'user': {
          'id': 101,
          'username': 'tarek',
          'avatarUrl': 'https://i.pravatar.cc/150?u=tarek',
        },
        'body': 'Thanks, I will adjust it',
        'createdAt': '2026-03-31T10:13:00.000Z',
      },
      {
        'id': 13,
        'user': {
          'id': 105,
          'username': 'karim',
          'avatarUrl': 'https://i.pravatar.cc/150?u=karim',
        },
        'body': 'real',
        'createdAt': '2026-03-31T10:14:00.000Z',
      },
    ],
    'pageNumber': 0,
    'pageSize': 20,
    'totalElements': 3,
    'totalPages': 1,
    'isLast': true,
  };
}
