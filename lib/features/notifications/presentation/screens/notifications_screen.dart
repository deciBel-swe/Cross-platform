import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../domain/entities/activity_notification.dart';
import '../notifiers/notification_feed_notifier.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(notificationFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationFeedProvider.notifier).markAllAsRead();
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (feedState) {
          if (feedState.notifications.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }

          // NotificationListener detects when the user scrolls
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // If we are at the bottom of the list, fetch the next page
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                ref.read(notificationFeedProvider.notifier).fetchNextPage();
              }
              return false;
            },
            child: ListView.builder(
              itemCount:
                  feedState.notifications.length +
                  (feedState.isFetchingNextPage ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading spinner at the very bottom if fetching next page
                if (index == feedState.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final notification = feedState.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    // Navigate based on the type of notification
                    switch (notification.resource.resourceType) {
                      case ResourceType.user:
                        final userIdStr = notification.resource.resourceId.toString();
                        context.go(RoutePaths.publicProfile(userIdStr));
                        break;
                      case ResourceType.track:
                        final trackId = notification.resource.resourceId;
                        context.go(RoutePaths.trackPreview(trackId));
                        break;
                      case ResourceType.playlist:
                        // TODO: Make it, when you finished the playlist
                        break;
                      case ResourceType.unknown:
                        break;
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
