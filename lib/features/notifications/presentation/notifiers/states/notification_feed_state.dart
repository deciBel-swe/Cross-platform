import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/activity_notification.dart';

part 'notification_feed_state.freezed.dart';

@freezed
class NotificationFeedState with _$NotificationFeedState {
  const factory NotificationFeedState({
    @Default([]) List<ActivityNotification> notifications,
    @Default(0) int currentPage,
    @Default(false) bool isLastPage,
    @Default(false) bool isFetchingNextPage,
  }) = _NotificationFeedState;
}
