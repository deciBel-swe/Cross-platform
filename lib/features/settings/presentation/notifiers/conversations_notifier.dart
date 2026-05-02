import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/conversation.dart';
import '../providers/messaging_providers.dart';
import '../state/conversations_state.dart';

/// Manages the state and business logic of the direct messaging inbox.
///
/// Features:
/// - Fetches initial conversation threads on initialization.
/// - Handles infinite scrolling pagination safely to prevent duplicate requests.
/// - Updates unread counters locally after opening or receiving messages.
class ConversationsNotifier extends AsyncNotifier<ConversationsState> {
  static const int _pageSize = 20;

  @override
  FutureOr<ConversationsState> build() async {
    return _fetchPage(0);
  }

  Future<ConversationsState> _fetchPage(int page) async {
    final repository = ref.read(messagingRepositoryProvider);
    final response = await repository.getConversations(
      page: page,
      size: _pageSize,
    );

    return ConversationsState(
      conversations: response.content,
      page: response.pageNumber,
      isLast: response.isLast,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _fetchPage(0));
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isLast || state.isLoading) return;

    final previousState = currentState;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(messagingRepositoryProvider);
      final response = await repository.getConversations(
        page: previousState.page + 1,
        size: _pageSize,
      );

      final existingIds = previousState.conversations.map((c) => c.id).toSet();
      final newConversations = response.content
          .where((conversation) => !existingIds.contains(conversation.id))
          .toList();

      return previousState.copyWith(
        conversations: [...previousState.conversations, ...newConversations],
        page: response.pageNumber,
        isLast: response.isLast,
      );
    });
  }

  void markConversationRead(String conversationId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final updatedConversations = currentState.conversations.map((conversation) {
      if (conversation.id != conversationId) return conversation;

      return Conversation(
        id: conversation.id,
        participants: conversation.participants,
        lastMessage: conversation.lastMessage,
        lastTimestamp: conversation.lastTimestamp,
        unreadCount: 0,
      );
    }).toList();

    state = AsyncData(
      currentState.copyWith(conversations: updatedConversations),
    );
  }

  void incrementUnreadCount(String conversationId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final updatedConversations = currentState.conversations.map((conversation) {
      if (conversation.id != conversationId) return conversation;

      return Conversation(
        id: conversation.id,
        participants: conversation.participants,
        lastMessage: conversation.lastMessage,
        lastTimestamp: conversation.lastTimestamp,
        unreadCount: conversation.unreadCount + 1,
      );
    }).toList();

    state = AsyncData(
      currentState.copyWith(conversations: updatedConversations),
    );
  }
}
