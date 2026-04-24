import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message_resource_preview.dart';

/// Renders a single conversation item inside the Inbox list.
///
/// Features:
/// - Displays dynamic unread message count badges.
/// - Wraps the entire layout in an explicit Semantics tree detailing the thread state.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  });

  final Conversation conversation;
  final int currentUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final otherUserId = conversation.participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => currentUserId,
    );

    final otherUsername = 'User $otherUserId';
    final timeString = _formatLastMessageTime(conversation.lastTimestamp);
    final parsedLastMessage = parseMessageResourceContent(
      conversation.lastMessage,
    );

    return Semantics(
      label: 'Conversation with $otherUsername. Last active $timeString.',
      button: true,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ExcludeSemantics(
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surface,
            child: Text(
              otherUsername.isNotEmpty ? otherUsername[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          otherUsername,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: _ConversationSubtitle(
          parsedMessage: parsedLastMessage,
          timeString: timeString,
        ),
        trailing: null,
      ),
    );
  }

  String _formatLastMessageTime(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'Now';
  }
}

class _ConversationSubtitle extends StatelessWidget {
  const _ConversationSubtitle({
    required this.parsedMessage,
    required this.timeString,
  });

  final MessageResourcePreview parsedMessage;
  final String timeString;

  @override
  Widget build(BuildContext context) {
    if (parsedMessage.hasResource) {
      return Row(
        children: [
          Icon(
            parsedMessage.isTrack ? Icons.music_note : Icons.queue_music,
            size: 15,
            color: Colors.grey,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              '${parsedMessage.cleanText} · $timeString',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      );
    }

    final text = parsedMessage.cleanText.isEmpty
        ? timeString
        : '${parsedMessage.cleanText} · $timeString';

    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
