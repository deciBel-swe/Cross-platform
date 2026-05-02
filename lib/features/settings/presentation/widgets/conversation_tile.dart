import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message_resource_preview.dart';
import '../providers/messaging_providers.dart';

/// Renders a single conversation item inside the inbox list.
///
/// The tile resolves the other participant's profile, displays the last
/// message summary, and marks the conversation as locally read before opening.
class ConversationTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final otherUserId = conversation.participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => currentUserId,
    );

    final profileAsync = ref.watch(messageUserProfileProvider(otherUserId));

    return profileAsync.when(
      data: (profile) {
        final displayName = profile.displayName?.trim();
        final username = profile.username.trim();

        final otherUsername = displayName != null && displayName.isNotEmpty
            ? displayName
            : username.isNotEmpty
            ? username
            : 'User $otherUserId';

        return _ConversationTileContent(
          conversation: conversation,
          otherUsername: otherUsername,
          onTap: () {
            ref
                .read(conversationsProvider.notifier)
                .markConversationRead(conversation.id);

            onTap();
          },
        );
      },
      loading: () {
        return _ConversationTileContent(
          conversation: conversation,
          otherUsername: 'Loading...',
          onTap: () {},
        );
      },
      error: (_, _) {
        return _ConversationTileContent(
          conversation: conversation,
          otherUsername: 'User $otherUserId',
          onTap: () {
            ref
                .read(conversationsProvider.notifier)
                .markConversationRead(conversation.id);

            onTap();
          },
        );
      },
    );
  }
}

/// Visual content for a conversation once the display name is known.
class _ConversationTileContent extends StatelessWidget {
  const _ConversationTileContent({
    required this.conversation,
    required this.otherUsername,
    required this.onTap,
  });

  final Conversation conversation;
  final String otherUsername;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeString = _formatLastMessageTime(conversation.lastTimestamp);
    final parsedLastMessage = parseMessageResourceContent(
      conversation.lastMessage,
    );
    final isUnread = conversation.unreadCount > 0;

    return Semantics(
      label:
          'Conversation with $otherUsername. Last active $timeString. ${isUnread ? '${conversation.unreadCount} unread messages.' : 'No unread messages.'}',
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.surface,
                child: Text(
                  _avatarLetter(otherUsername),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUsername,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isUnread
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _ConversationSubtitle(
                      parsedMessage: parsedLastMessage,
                      timeString: timeString,
                      isUnread: isUnread,
                    ),
                  ],
                ),
              ),
              if (isUnread) ...[
                const SizedBox(width: 10),
                _UnreadBadge(count: conversation.unreadCount),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the initial used inside the avatar bubble.
  static String _avatarLetter(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }

  /// Formats the conversation timestamp into a short relative label.
  String _formatLastMessageTime(DateTime date) {
    final now = DateTime.now();
    final safeDate = date.isAfter(now) ? now : date;
    final difference = now.difference(safeDate);

    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'Now';
  }
}

/// Last-message summary row for text or shared resource conversations.
class _ConversationSubtitle extends StatelessWidget {
  const _ConversationSubtitle({
    required this.parsedMessage,
    required this.timeString,
    required this.isUnread,
  });

  final MessageResourcePreview parsedMessage;
  final String timeString;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: isUnread ? Colors.white70 : Colors.grey,
      fontSize: 13,
      fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
    );

    if (parsedMessage.hasResource) {
      final label = parsedMessage.isTrack ? 'Track' : 'Playlist';

      return Row(
        children: [
          Icon(
            parsedMessage.isTrack ? Icons.music_note : Icons.queue_music,
            size: 15,
            color: isUnread ? Colors.white70 : Colors.grey,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              '$label · $timeString',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      );
    }

    final cleanText = parsedMessage.cleanText.trim();
    final text = cleanText.isEmpty ? timeString : '$cleanText · $timeString';

    return Text(
      text,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Compact unread-count pill shown on conversations with unread messages.
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : count.toString();

    return ExcludeSemantics(
      child: Container(
        width: count > 99 ? 34 : 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: count > 99 ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: count > 99 ? BorderRadius.circular(999) : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
