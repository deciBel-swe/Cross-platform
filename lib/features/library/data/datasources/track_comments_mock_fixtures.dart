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
      {
        'id': 14,
        'user': {
          'id': 106,
          'username': 'omar',
          'avatarUrl': 'https://i.pravatar.cc/150?u=omar',
        },
        'body': 'can u share the preset?',
        'createdAt': '2026-03-31T10:15:00.000Z',
      },
      {
        'id': 15,
        'user': {
          'id': 107,
          'username': 'lara',
          'avatarUrl': 'https://i.pravatar.cc/150?u=lara',
        },
        'body': 'Insane work 🔥',
        'createdAt': '2026-03-31T10:16:00.000Z',
      },
      {
        'id': 16,
        'user': {
          'id': 108,
          'username': 'ahmed',
          'avatarUrl': 'https://i.pravatar.cc/150?u=ahmed',
        },
        'body': 'this is so good',
        'createdAt': '2026-03-31T10:17:00.000Z',
      },
      {
        'id': 17,
        'user': {
          'id': 109,
          'username': 'fatima',
          'avatarUrl': 'https://i.pravatar.cc/150?u=fatima',
        },
        'body': 'wow',
        'createdAt': '2026-03-31T10:18:00.000Z',
      },
      {
        'id': 18,
        'user': {
          'id': 110,
          'username': 'youssef',
          'avatarUrl': 'https://i.pravatar.cc/150?u=youssef',
        },
        'body': 'keep it up',
        'createdAt': '2026-03-31T10:19:00.000Z',
      },
      {
        'id': 19,
        'user': {
          'id': 111,
          'username': 'nada',
          'avatarUrl': 'https://i.pravatar.cc/150?u=nada',
        },
        'body': 'amazing!',
        'createdAt': '2026-03-31T10:20:00.000Z',
      },
      {
        'id': 20,
        'user': {
          'id': 112,
          'username': 'mahmoud',
          'avatarUrl': 'https://i.pravatar.cc/150?u=mahmoud',
        },
        'body': 'what synth did you use?',
        'createdAt': '2026-03-31T10:21:00.000Z',
      },
      {
        'id': 21,
        'user': {
          'id': 113,
          'username': 'layla',
          'avatarUrl': 'https://i.pravatar.cc/150?u=layla',
        },
        'body': 'the bass is heavy',
        'createdAt': '2026-03-31T10:22:00.000Z',
      },
      {
        'id': 22,
        'user': {
          'id': 114,
          'username': 'khaled',
          'avatarUrl': 'https://i.pravatar.cc/150?u=khaled',
        },
        'body': 'dope',
        'createdAt': '2026-03-31T10:23:00.000Z',
      },
      {
        'id': 23,
        'user': {
          'id': 115,
          'username': 'hoda',
          'avatarUrl': 'https://i.pravatar.cc/150?u=hoda',
        },
        'body': 'can\'t stop listening',
        'createdAt': '2026-03-31T10:24:00.000Z',
      },
      {
        'id': 24,
        'user': {
          'id': 116,
          'username': 'ramy',
          'avatarUrl': 'https://i.pravatar.cc/150?u=ramy',
        },
        'body': 'needs more cowbell',
        'createdAt': '2026-03-31T10:25:00.000Z',
      },
      {
        'id': 25,
        'user': {
          'id': 117,
          'username': 'samy',
          'avatarUrl': 'https://i.pravatar.cc/150?u=samy',
        },
        'body': 'perfect track',
        'createdAt': '2026-03-31T10:26:00.000Z',
      },
    ],
    'pageNumber': 0,
    'pageSize': 20,
    'totalElements': 15,
    'totalPages': 1,
    'isLast': true,
  };
}
