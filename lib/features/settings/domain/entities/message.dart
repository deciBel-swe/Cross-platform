import 'resource_type.dart';

/// Represents a single message within a conversation thread.
class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.resourceType,
    this.resourceId,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String? conversationId;
  final int senderId;
  final String content;
  final ResourceType? resourceType;
  final int? resourceId;
  final DateTime createdAt;
  final bool isRead;
}
