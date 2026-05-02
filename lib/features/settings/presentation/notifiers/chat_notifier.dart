import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/message_resource_preview.dart';
import '../../domain/entities/resource_type.dart';
import '../providers/messaging_providers.dart';
import '../state/chat_state.dart';

/// Manages the message history and sending logic for a single conversation.
///
/// Features:
/// - Loads paginated message history dynamically based on user scrolling.
/// - Optimistically updates the local state array when a new message is dispatched.
class ChatNotifier extends FamilyAsyncNotifier<ChatState, String> {
  static const int _pageSize = 20;

  @override
  FutureOr<ChatState> build(String arg) async {
    return _fetchPage(0);
  }

  Future<ChatState> _fetchPage(int page) async {
    final repository = ref.read(messagingRepositoryProvider);
    final response = await repository.getMessages(
      conversationId: arg,
      page: page,
      size: _pageSize,
    );

    return ChatState(
      messages: response.content,
      page: response.pageNumber,
      isLast: response.isLast,
    );
  }

  Future<void> loadMoreHistory() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isLast || state.isLoading) return;

    try {
      final repository = ref.read(messagingRepositoryProvider);
      final response = await repository.getMessages(
        conversationId: arg,
        page: currentState.page + 1,
        size: _pageSize,
      );

      state = AsyncData(
        currentState.copyWith(
          messages: [...currentState.messages, ...response.content],
          page: response.pageNumber,
          isLast: response.isLast,
        ),
      );
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> sendMessage(
    String text, {
    ResourceType? resourceType,
    int? resourceId,
    int? recipientId,
  }) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    try {
      final repository = ref.read(messagingRepositoryProvider);
      final newMessage = await repository.sendMessage(
        conversationId: arg,
        content: text,
        resourceType: resourceType,
        resourceId: resourceId,
        recipientId: recipientId,
      );

      state = AsyncData(
        currentState.copyWith(messages: [newMessage, ...currentState.messages]),
      );

      ref.invalidate(conversationsProvider);

      Future.microtask(() {
        ref.invalidateSelf();
      });

      state = AsyncData(
        currentState.copyWith(messages: [newMessage, ...currentState.messages]),
      );

      ref.invalidate(conversationsProvider);
    } catch (e) {
      throw Exception('Failed to dispatch message.');
    }
  }

  Future<void> sendResourceMessage({
    required String resourceType,
    required int resourceId,
    required String title,
    String? subtitle,
    String? imageUrl,
    int? recipientId,
  }) async {
    final content = buildResourceMessageContent(
      resourceType: resourceType,
      resourceId: resourceId,
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
    );

    await sendMessage(content, recipientId: recipientId);
  }
}
