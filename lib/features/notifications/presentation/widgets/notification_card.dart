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

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // Subtle highlight for unread notifications
          color: notification.isRead
              ? Colors.transparent
              : AppColors.surface.withOpacity(0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Actor Avatar placeholder
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: const Icon(Icons.person, color: AppColors.primary),
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
                          text: notification.user.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' $actionText'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notification.createdAt),
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
    );
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

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
