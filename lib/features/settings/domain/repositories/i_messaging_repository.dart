import '../entities/conversation.dart';
import '../entities/message.dart';
import '../entities/paginated_data.dart';
import '../entities/resource_type.dart';

/// Contract for messaging data operations.
///
/// Throws [Failure] subclasses on errors.
abstract class IMessagingRepository {
  /// Fetches a paginated list of the user's active DM threads.
  Future<PaginatedData<Conversation>> getConversations({
    int page = 0,
    int size = 20,
  });

  /// Starts a new conversation with the target user and returns the conversation ID.
  Future<String> startConversation(int targetUserId);

  /// Fetches paginated messages within a specific conversation thread.
  Future<PaginatedData<Message>> getMessages({
    required String conversationId,
    int page = 0,
    int size = 20,
  });

  /// Sends a new message in the specified conversation thread.
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
    ResourceType? resourceType,
    int? resourceId,
    int? recipientId,
  });
}
