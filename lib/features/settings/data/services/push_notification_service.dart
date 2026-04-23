import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  static const String _tokenKey = 'fcm_device_token';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      await _messaging.setAutoInitEnabled(true);

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint(
        '[FCM] permission status: ${settings.authorizationStatus.name}',
      );

      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await _saveToken(token);
        debugPrint('[FCM] token: $token');
      }

      _messaging.onTokenRefresh.listen((token) async {
        await _saveToken(token);
        debugPrint('[FCM] refreshed token: $token');
      });
    } catch (e) {
      debugPrint('[FCM] initialization failed: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}