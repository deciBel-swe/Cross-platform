import 'message_user.dart';

/// Represents a direct messaging thread between two users.
class Conversation {
  const Conversation({
    required this.id,
    required this.user1,
    required this.user2,
    required this.unreadCount,
    required this.lastMessageAt,
  });

  final int id;
  final MessageUser user1;
  final MessageUser user2;
  final int unreadCount;
  final DateTime lastMessageAt;
}
