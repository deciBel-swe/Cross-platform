import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/activity_notification.dart';
import '../providers/notification_providers.dart';
import 'states/notification_feed_state.dart';
import 'unread_count_notifier.dart';

final notificationFeedProvider =
    AsyncNotifierProvider<NotificationFeedNotifier, NotificationFeedState>(
      NotificationFeedNotifier.new,
    );

class NotificationFeedNotifier extends AsyncNotifier<NotificationFeedState> {
  static const int _pageSize = 20;

  @override
  FutureOr<NotificationFeedState> build() async {
    return _fetchInitialPage();
  }

  Future<NotificationFeedState> _fetchInitialPage() async {
    final repository = ref.watch(notificationRepositoryProvider);
    final (failure, notifications) = await repository.getNotifications(
      0,
      _pageSize,
    );

    if (failure != null) {
      throw Exception(failure.message);
    }

    final data = notifications ?? [];
    return NotificationFeedState(
      notifications: data,
      currentPage: 0,
      isLastPage: data.length < _pageSize,
    );
  }

  /// Called by the UI when the user scrolls near the bottom of the list.
  Future<void> fetchNextPage() async {
    final currentState = state.valueOrNull;

    // Prevent duplicate requests while already fetching, or if we hit the end
    if (currentState == null ||
        currentState.isLastPage ||
        currentState.isFetchingNextPage) {
      return;
    }

    // 1. Update state to show loading indicator at the bottom of the list
    state = AsyncData(currentState.copyWith(isFetchingNextPage: true));

    final repository = ref.read(notificationRepositoryProvider);
    final nextPage = currentState.currentPage + 1;

    final (failure, newNotifications) = await repository.getNotifications(
      nextPage,
      _pageSize,
    );

    if (failure != null) {
      // Revert loading state quietly if it fails, allowing user to try scrolling again
      state = AsyncData(currentState.copyWith(isFetchingNextPage: false));
      return;
    }

    final data = newNotifications ?? [];

    // 2. Append new data to the existing list
    state = AsyncData(
      currentState.copyWith(
        notifications: [...currentState.notifications, ...data],
        currentPage: nextPage,
        isLastPage: data.length < _pageSize,
        isFetchingNextPage: false,
      ),
    );
  }

  /// Marks all notifications as read on the backend and updates the UI locally.
  Future<void> markAllAsRead() async {
    final repository = ref.read(notificationRepositoryProvider);
    final failure = await repository.markAllAsRead();

    if (failure == null) {
      // 1. Tell the badge provider to reset its count to 0
      ref.read(unreadCountProvider.notifier).clearBadge();

      // 2. Update all local notifications so their UI unread dot disappears
      final currentState = state.valueOrNull;
      if (currentState != null) {
        final updatedNotifications = currentState.notifications.map((n) {
          // construct a new instance with the updated boolean.
          return ActivityNotification(
            id: n.id,
            type: n.type,
            isRead: true,
            createdAt: n.createdAt,
            user: n.user,
            resource: n.resource,
          );
        }).toList();

        state = AsyncData(
          currentState.copyWith(notifications: updatedNotifications),
        );
      }
    } else {
      // TODO: Could use a global SnackbarService to show the failure.message here
    }
  }
}
