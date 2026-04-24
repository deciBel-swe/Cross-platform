/// Screen displaying the active message history between two distinct users.
///
/// Features:
/// - Real-time automated refresh via Firebase Cloud Messaging foreground streams.
/// - Infinite scroll detection for retrieving older message history seamlessly.
/// - Highly semantic and scalable layout optimized for screen readers.
library;

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/messaging_providers.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_resource_picker_sheet.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  final String conversationId;
  final String otherUserName;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _setupFirebaseForegroundListener();
  }

  void _setupFirebaseForegroundListener() {
    _fcmSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      final dataConversationId = message.data['conversationId'];
      if (dataConversationId != null &&
          dataConversationId.toString() == widget.conversationId) {
        ref.invalidate(chatProvider(widget.conversationId));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fcmSubscription?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(chatProvider(widget.conversationId).notifier).loadMoreHistory();
    }
  }

  int? _resolveOtherUserId(int currentUserId) {
    try {
      final participantIds = widget.conversationId
          .split('_')
          .map(int.parse)
          .toList();

      return participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => currentUserId,
      );
    } catch (_) {
      return null;
    }
  }

  void _handleSendMessage(String text, int? recipientId) {
    if (text.trim().isEmpty) return;

    ref
        .read(chatProvider(widget.conversationId).notifier)
        .sendMessage(text, recipientId: recipientId);
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.conversationId));
    final authState = ref.watch(authStateProvider).valueOrNull;

    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : 1;

    final otherUserId = _resolveOtherUserId(currentUserId);

    return Semantics(
      label: 'Chat conversation with ${widget.otherUserName}',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Semantics(
            header: true,
            child: Text(
              widget.otherUserName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            Semantics(
              button: true,
              label: 'Cast media to device',
              child: IconButton(
                icon: const Icon(Icons.cast, color: Colors.white),
                onPressed: () {},
              ),
            ),
            Semantics(
              button: true,
              label: 'Expand options menu',
              child: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: chatAsync.when(
                data: (state) {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: state.messages.length + (state.isLast ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index >= state.messages.length) {
                        return Semantics(
                          label: 'Loading older messages in conversation',
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      final message = state.messages[index];
                      final isMe = message.senderId == currentUserId;

                      return MessageBubble(
                        message: message,
                        isMe: isMe,
                        otherUserId: isMe ? null : otherUserId,
                      );
                    },
                  );
                },
                loading: () => Semantics(
                  label: 'Loading chat messages',
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Center(
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
            ChatInputBar(
              onSend: (text) {
                if (otherUserId == null) return;

                ref
                    .read(chatProvider(widget.conversationId).notifier)
                    .sendMessage(text, recipientId: otherUserId);
              },
              onAttach: () async {
                if (otherUserId == null) return;

                final selection = await MessageResourcePickerSheet.show(
                  context,
                );
                if (selection == null) return;

                await ref
                    .read(chatProvider(widget.conversationId).notifier)
                    .sendResourceMessage(
                      resourceType: selection.resourceType,
                      resourceId: selection.resourceId,
                      title: selection.title,
                      subtitle: selection.subtitle,
                      imageUrl: selection.imageUrl,
                      recipientId: otherUserId,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
