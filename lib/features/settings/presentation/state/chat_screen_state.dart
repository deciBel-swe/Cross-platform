import '../../domain/entities/message.dart';

class ChatScreenState {
  const ChatScreenState({
    required this.conversationId,
    required this.currentUserId,
    required this.otherUserId,
  });

  final String conversationId;
  final int currentUserId;
  final int? otherUserId;

  bool get canSend => otherUserId != null;

  bool isMessageFromMe(Message message) {
    return message.senderId == currentUserId;
  }
}
