import '../../domain/entities/message.dart';

/// State container for a specific conversation thread.
///
/// Features:
/// - Maintains the messages loaded for the current active chat.
/// - Tracks the pagination index for history fetching.
/// - Indicates whether the entire chat history has been loaded.
class ChatState {
  const ChatState({
    required this.messages,
    required this.page,
    required this.isLast,
  });

  final List<Message> messages;
  final int page;
  final bool isLast;

  ChatState copyWith({List<Message>? messages, int? page, bool? isLast}) {
    return ChatState(
      messages: messages ?? this.messages,
      page: page ?? this.page,
      isLast: isLast ?? this.isLast,
    );
  }
}
