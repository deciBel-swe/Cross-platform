/// Visually renders an individual chat message inside a conversation context.
///
/// Features:
/// - Automatically shifts alignment based on message sender context (Me vs Them).
/// - Routes to the other user's public profile when tapping the avatar.
/// - Conditionally evaluates and displays embedded rich media objects seamlessly.
/// - Enforces comprehensive explicit semantic boundaries across textual nodes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_resource_preview.dart';
import 'message_bubble_content.dart';
import 'message_bubble_sender_avatar.dart';
import 'message_bubble_timestamp.dart';

/// Chat bubble that renders text, shared resources, sender avatar, and time.
///
/// [isMe] controls alignment and whether a sender avatar is shown.
class MessageBubble extends ConsumerWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.otherUserId,
  });

  final Message message;
  final bool isMe;
  final int? otherUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeString = _formatTimeAgo(message.createdAt);
    final parsed = parseMessageResourceContent(message.content);

    return Semantics(
      label:
          'Message from ${isMe ? 'You' : 'Them'}, sent $timeString. '
          '${parsed.hasResource ? 'Contains shared ${parsed.resourceType?.toLowerCase()}.' : ''} '
          'Message reads: ${parsed.cleanText.isEmpty ? parsed.displayTitle : parsed.cleanText}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              MessageBubbleSenderAvatar(otherUserId: otherUserId),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: MessageBubbleContent(parsed: parsed),
                  ),
                  const SizedBox(height: 6),
                  MessageBubbleTimestamp(timeString: timeString),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a message creation time into a conversational relative label.
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final safeDate = date.isAfter(now) ? now : date;
    final difference = now.difference(safeDate);

    if (difference.inDays > 30) {
      final months = difference.inDays ~/ 30;
      return '$months month${months == 1 ? '' : 's'} ago';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }

    if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }

    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    }

    return 'Just now';
  }
}
