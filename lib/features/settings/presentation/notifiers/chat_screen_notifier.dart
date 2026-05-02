import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/message.dart';
import '../providers/messaging_providers.dart';
import '../state/chat_screen_state.dart';

class ChatScreenNotifier extends FamilyNotifier<ChatScreenState, String> {
  @override
  ChatScreenState build(String conversationId) {
    final authState = ref.watch(authStateProvider).valueOrNull;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : 1;
    final otherUserId = _resolveOtherUserId(conversationId, currentUserId);

    ref.listen(chatForegroundConversationIdProvider, (_, next) {
      if (next.valueOrNull == conversationId) {
        ref.invalidate(chatProvider(conversationId));
      }
    });

    return ChatScreenState(
      conversationId: conversationId,
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }

  Future<void> loadMoreHistory() async {
    await ref.read(chatProvider(arg).notifier).loadMoreHistory();
  }

  Future<void> sendTextMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final screenState = state;
    final recipientId = screenState.otherUserId;
    if (recipientId == null) return;

    await ref
        .read(chatProvider(arg).notifier)
        .sendMessage(trimmed, recipientId: recipientId);
  }

  Future<void> sendResourceMessage({
    required String resourceType,
    required int resourceId,
    required String title,
    String? subtitle,
    String? imageUrl,
  }) async {
    final recipientId = state.otherUserId;
    if (recipientId == null) return;

    await ref
        .read(chatProvider(arg).notifier)
        .sendResourceMessage(
          resourceType: resourceType,
          resourceId: resourceId,
          title: title,
          subtitle: subtitle,
          imageUrl: imageUrl,
          recipientId: recipientId,
        );
  }

  bool isMessageFromMe(Message message) {
    return message.senderId == state.currentUserId;
  }

  int? _resolveOtherUserId(String conversationId, int currentUserId) {
    try {
      final participantIds = conversationId.split('_').map(int.parse).toList();

      return participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => currentUserId,
      );
    } catch (_) {
      return null;
    }
  }
}
