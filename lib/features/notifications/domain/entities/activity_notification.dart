enum NotificationType { follow, like, repost, comment, reply, unknown }
enum ResourceType { user, track, playlist, unknown }

class NotificationUser {
  const NotificationUser({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
  });

  final int id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
}

class NotificationResource {
  const NotificationResource({
    required this.resourceType,
    required this.resourceId,
  });

  final ResourceType resourceType;
  final int resourceId;
}

class ActivityNotification {
  const ActivityNotification({
    required this.id,
    required this.type,
    required this.user,
    required this.resource,
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final NotificationType type;
  final NotificationUser user;
  final NotificationResource resource;
  final bool isRead;
  final DateTime createdAt;
}