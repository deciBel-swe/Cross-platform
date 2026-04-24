import '../../domain/entities/conversation.dart';

/// State container for the user's inbox.
///
/// Features:
/// - Holds the list of loaded conversation threads.
/// - Tracks the current pagination page index.
/// - Indicates whether the end of the remote list has been reached.
class ConversationsState {
  const ConversationsState({
    required this.conversations,
    required this.page,
    required this.isLast,
  });

  final List<Conversation> conversations;
  final int page;
  final bool isLast;

  ConversationsState copyWith({
    List<Conversation>? conversations,
    int? page,
    bool? isLast,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      page: page ?? this.page,
      isLast: isLast ?? this.isLast,
    );
  }
}
