import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/activity_notification.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final ActivityNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine the action text based on the enum
    final String actionText = _getActionText(notification.type);
    final userLabel =
        notification.user.displayName ?? notification.user.username;
    final avatarImageProvider = _avatarImageProvider(
      notification.user.avatarUrl,
    );
    final timeLabel = _formatTime(notification.createdAt);
    final readStateLabel = notification.isRead ? 'Read' : 'Unread';
    final hasDestination = _hasDestination(notification.resource.resourceType);

    return Semantics(
      container: true,
      button: true,
      enabled: hasDestination,
      label: '$readStateLabel notification. $userLabel $actionText. $timeLabel',
      hint: _navigationHint(notification.resource.resourceType),
      child: ExcludeSemantics(
        child: InkWell(
          onTap: hasDestination ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              // Subtle highlight for unread notifications
              color: notification.isRead
                  ? Colors.transparent
                  : AppColors.surface.withValues(alpha: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                  backgroundImage: avatarImageProvider,
                  child: avatarImageProvider == null
                      ? const Icon(Icons.person, color: AppColors.primary)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: userLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' $actionText'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider? _avatarImageProvider(String? avatarUrl) {
    final normalizedAvatarUrl = avatarUrl?.trim();
    if (normalizedAvatarUrl == null || normalizedAvatarUrl.isEmpty) {
      return null;
    }

    return CachedNetworkImageProvider(normalizedAvatarUrl);
  }

  String _getActionText(NotificationType type) {
    switch (type) {
      case NotificationType.follow:
        return 'started following you';
      case NotificationType.like:
        return 'liked your track';
      case NotificationType.repost:
        return 'reposted your track';
      case NotificationType.comment:
        return 'commented on your track';
      case NotificationType.reply:
        return 'replied to your comment';
      case NotificationType.unknown:
        return 'interacted with your content';
    }
  }

  String _navigationHint(ResourceType type) {
    switch (type) {
      case ResourceType.user:
        return 'Opens the user profile';
      case ResourceType.track:
        return 'Opens the track';
      case ResourceType.playlist:
        return 'Playlist details are not available yet';
      case ResourceType.unknown:
        return 'No destination available';
    }
  }

  bool _hasDestination(ResourceType type) {
    switch (type) {
      case ResourceType.user:
      case ResourceType.track:
        return true;
      case ResourceType.playlist:
      case ResourceType.unknown:
        return false;
    }
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
