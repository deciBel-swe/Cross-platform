import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../domain/entities/activity_notification.dart';
import '../notifiers/notification_feed_notifier.dart';
import '../notifiers/unread_count_notifier.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (!mounted) {
        return;
      }

      ref.invalidate(notificationFeedProvider);
      ref.invalidate(unreadCountProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(notificationFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Semantics(
            button: true,
            label: 'Mark all notifications as read',
            hint: 'Marks every notification in this list as read',
            child: TextButton(
              onPressed: () {
                ref.read(notificationFeedProvider.notifier).markAllAsRead();
              },
              child: const Text('Mark all as read'),
            ),
          ),
        ],
      ),
      body: Semantics(
        container: true,
        explicitChildNodes: true,
        label: 'Notifications screen',
        child: feedAsync.when(
          loading: () => Center(
            child: Semantics(
              label: 'Loading notifications',
              liveRegion: true,
              child: const CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Semantics(
              liveRegion: true,
              label: 'Failed to load notifications',
              child: Text('Error: $error'),
            ),
          ),
          data: (feedState) {
            if (feedState.notifications.isEmpty) {
              return Center(
                child: Semantics(
                  liveRegion: true,
                  label: 'No notifications yet',
                  child: const Text('No notifications yet.'),
                ),
              );
            }

            return RefreshIndicator(
              semanticsLabel: 'Refresh notifications',
              onRefresh: () async {
                ref.invalidate(notificationFeedProvider);
                await ref.read(notificationFeedProvider.future);
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    ref.read(notificationFeedProvider.notifier).fetchNextPage();
                  }
                  return false;
                },
                child: ListView.builder(
                  semanticChildCount: feedState.notifications.length,
                  itemCount:
                      feedState.notifications.length +
                      (feedState.isFetchingNextPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == feedState.notifications.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Semantics(
                            label: 'Loading more notifications',
                            liveRegion: true,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    final notification = feedState.notifications[index];
                    return NotificationCard(
                      notification: notification,
                      onTap: () {
                        switch (notification.resource.resourceType) {
                          case ResourceType.user:
                            final userIdStr =
                                notification.resource.resourceId.toString();
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
              ),
            );
          },
        ),
      ),
    );
  }
}
