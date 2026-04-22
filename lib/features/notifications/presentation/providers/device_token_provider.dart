import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/firebase_messaging_service.dart.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../../core/di/injection.dart'; 

/// A FutureProvider that runs once on startup to sync the FCM token with the backend.
final syncDeviceTokenProvider = FutureProvider<void>((ref) async {
  final firebaseService = getIt<FirebaseMessagingService>();
  final repository = getIt<INotificationRepository>();

  // 1. Ask user for notification permissions (Crucial for iOS)
  final hasPermission = await firebaseService.requestPermission();
  
  if (hasPermission) {
    // 2. Get the token from Firebase
    try {
      final token = await firebaseService.getDeviceToken();
      debugPrint('[PushNotifications] FCM Token retrieved: $token');
      
      if (token != null) {
        // 3. Send it to our Decibel backend
        final failure = await repository.registerDeviceToken(token);
        
        if (failure != null) {
          debugPrint('[PushNotifications] Backend sync failed: ${failure.message}');
        } else {
          debugPrint('[PushNotifications] Token successfully registered with backend!');
        }
      } else {
        debugPrint('[PushNotifications] FCM Token was null.');
      }
    } catch (e) {
      debugPrint('[PushNotifications] Error fetching token from Firebase: $e');
    }
  } else {
    debugPrint('[PushNotifications] Cannot sync token: User denied permissions.');
  }
});