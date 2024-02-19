// File: firebase_notification.dart
// Description: This file contains the implementation of a Firebase Cloud Messaging (FCM) service
// for handling push notifications in a Flutter application using the Firebase Messaging package.

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification.dart';

// Handle background messages when the app is in the background or terminated
Future<void> backgroundHandler(RemoteMessage message) async {
  openNotification(message.data);
}

class FirebaseNotificationService {
  // Get the FCM token for the device
  static Future<String?> fcmDeviceToken() async => await FirebaseMessaging.instance.getToken();

  // Initialize Firebase Cloud Messaging
  static Future<void> initialized() async {
    if (Platform.isAndroid) {
      // Initialize local notifications for Android
      await LocalNotificationService.initialized();
    }
    requestPermission();

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // If the app is terminated and the user clicks on a notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        openNotification(message.data);
      }
    });

    // If the app is in the foreground, handle incoming messages
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (Platform.isAndroid) {
          // Local Notification Code to Display Alert
          LocalNotificationService.show(remoteMessage: message);
        }
      }
    });

    // If the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        openNotification(message.data);
      }
    });

    // Set foreground notification presentation options
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  // Request permission for notifications on iOS
  static Future<NotificationSettings> requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings;
  }

  // Subscribe to an FCM topic
  static Future<void> fcmSubscribe({required String topic}) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  // Unsubscribe from an FCM topic
  static Future<void> fcmUnSubscribe({required String topic}) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
