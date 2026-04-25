/// Screen displaying the active message history between two distinct users.
///
/// Features:
/// - Real-time automated refresh via Firebase Cloud Messaging foreground streams.
/// - Infinite scroll detection for retrieving older message history seamlessly.
/// - Highly semantic and scalable layout optimized for screen readers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/presentation/providers/block_provider.dart'
    as profile_block;
import '../providers/blocked_users_provider.dart' as settings_block;
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      ref.read(settings_block.blockedUsersListProvider.notifier).loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(chatScreenControllerProvider(widget.conversationId).notifier)
          .loadMoreHistory();
    }
  }

  Future<void> _blockUser({
    required int userId,
    required String username,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Block user?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'You will not be able to send messages to $username.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Block',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(profile_block.blockedUsersProvider.notifier)
          .block(userId, username: username);

      await ref
          .read(settings_block.blockedUsersListProvider.notifier)
          .refresh();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$username blocked.')));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to block user.')));
    }
  }

  Future<void> _unblockUser({
    required int userId,
    required String username,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Unblock user?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'You will be able to send messages to $username again.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Unblock'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(profile_block.blockedUsersProvider.notifier)
          .unblock(userId);

      await ref
          .read(settings_block.blockedUsersListProvider.notifier)
          .refresh();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$username unblocked.')));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to unblock user.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.conversationId));
    final screenState = ref.watch(
      chatScreenControllerProvider(widget.conversationId),
    );
    final chatController = ref.read(
      chatScreenControllerProvider(widget.conversationId).notifier,
    );

    final otherUserId = screenState.otherUserId;
    final blockedListState = ref.watch(settings_block.blockedUsersListProvider);
    final localBlockedIds = ref.watch(profile_block.blockedUsersProvider);

    final isBlocked =
        otherUserId != null &&
        (localBlockedIds.contains(otherUserId) ||
            blockedListState.users.any((user) => user.id == otherUserId));

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
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: AppColors.surface,
              onSelected: (value) {
                if (otherUserId == null) return;

                if (value == 'block') {
                  _blockUser(
                    userId: otherUserId,
                    username: widget.otherUserName,
                  );
                }

                if (value == 'unblock') {
                  _unblockUser(
                    userId: otherUserId,
                    username: widget.otherUserName,
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: isBlocked ? 'unblock' : 'block',
                  child: Row(
                    children: [
                      Icon(
                        isBlocked ? Icons.lock_open : Icons.block,
                        color: isBlocked ? Colors.white : Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isBlocked ? 'Unblock user' : 'Block user',
                        style: TextStyle(
                          color: isBlocked ? Colors.white : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                      final isMe = screenState.isMessageFromMe(message);

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
            if (isBlocked)
              SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    'You blocked this user. You cannot send messages.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
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
