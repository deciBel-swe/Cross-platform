/// Represents a direct messaging thread between two users.
class Conversation {
  const Conversation({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastTimestamp,
    this.unreadCount = 0,
  });

  final String id;
  final List<int> participants;
  final String lastMessage;
  final DateTime lastTimestamp;
  final int unreadCount;
}
