import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

/// Service responsible for handling Firebase Cloud Messaging (FCM).
///
/// Manages requesting permissions, retrieving the FCM device token,
/// and exposing streams for foreground notifications.
@lazySingleton
class FirebaseMessagingService {
  FirebaseMessagingService();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Requests notification permissions from the user (Required for iOS).
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Retrieves the current FCM registration token for this device.
  /// This is the token we will send to the backend.
  Future<String?> getDeviceToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      // TODO(team): Add proper logging here based on your logging package
      return null;
    }
  }

  /// Stream of incoming messages while the app is in the foreground.
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;
}
