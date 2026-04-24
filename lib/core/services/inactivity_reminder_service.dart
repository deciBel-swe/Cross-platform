import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

/// Schedules a local reminder if the user leaves Decibel unopened for a while.
class InactivityReminderService {
  InactivityReminderService();

  static const Duration inactivityDelay = Duration(days: 3);

  static const int _notificationId = 7001;
  static const String _channelId = 'inactivity_reminders';
  static const String _channelName = 'Listening reminders';
  static const String _channelDescription =
      'Reminders to return to Decibel after being away.';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void>? _initializeFuture;

  Future<void> initialize() {
    return _initializeFuture ??= _initialize();
  }

  Future<void> scheduleReminder({Duration delay = inactivityDelay}) async {
    await initialize();
    await cancelReminder();

    final scheduledDate = timezone.TZDateTime.now(timezone.UTC).add(delay);

    await _notifications.zonedSchedule(
      _notificationId,
      'Your Decibel feed is waiting',
      'Catch up on new likes, follows, and comments.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(threadIdentifier: _channelId),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'inactivity_reminder',
    );
  }

  Future<void> cancelReminder() async {
    await initialize();
    await _notifications.cancel(_notificationId);
  }

  Future<void> _initialize() async {
    timezone_data.initializeTimeZones();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _notifications.initialize(initializationSettings);
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    try {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (error) {
      debugPrint('[InactivityReminder] Permission request skipped: $error');
    }
  }
}
