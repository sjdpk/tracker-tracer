// File: local_notificatio.dart
// Description: This file contains the implementation of a local notification service and fsm notification service.
// using the Flutter Local Notifications Plugin for handling and displaying
// notifications in a Flutter application.

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tracker/src/config/router/app_routes.dart';
import 'firebase.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _notificationService = LocalNotificationService._internal();
  factory LocalNotificationService() {
    return _notificationService;
  }
  LocalNotificationService._internal();
  // Flutter Local Notifications Plugin instance
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static Future<void> initialized() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );
    DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        // display a dialog with the notification details, tap to open the app
      },
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse data) {
        var payloadObj = json.decode(data.payload ?? "{}") as Map? ?? {};
        openNotification(payloadObj);
      },
      onDidReceiveBackgroundNotificationResponse: localBackgroundHandler,
    );
    // *** Initialize timezone here ***
    await _configureLocalTimeZone();
  }

  // Request permission for notifications on iOS
  static Future<bool?> requestPermission() async {
    final bool? result = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? false;
  }

  Future<NotificationResponse?> getInitialNotification() async {
    final launchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      return NotificationResponse(notificationResponseType: NotificationResponseType.selectedNotification, payload: launchDetails!.notificationResponse!.payload);
    }
    return null;
  }

  // Android notification details for local notifications
  static AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
    'general',
    'reminder',
    playSound: true,
    channelDescription: 'reminder for your schedule task',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  // iOS notification details for local notifications
  static DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // Display a local notification based on a RemoteMessage
  static void show({int? id, RemoteMessage? remoteMessage, String? title, String? body, NotificationDetails? notificationDetails, String? payload}) async {
    try {
      id ??= DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );
      if (remoteMessage != null) {
        await flutterLocalNotificationsPlugin.show(
          id,
          remoteMessage.notification!.title,
          remoteMessage.notification!.body,
          notificationDetails,
          payload: json.encode(remoteMessage.data),
        );
      } else {
        await flutterLocalNotificationsPlugin.show(
          id,
          title,
          body,
          notificationDetails,
          payload: json.encode(payload ?? ""),
        );
      }
    } on Exception catch (e, stackTrace) {
      FirebaseCrashLogger.nonFatalError(error: e, stackTrace: stackTrace);
    }
  }

  /// Schedule a local notification after a specified time
  /// Here, time is in seconds
  static schedule({int id = 0, required DateTime dateTime, required String? title, required String? body, required String? payload}) async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title ?? 'Have a look at your expenses',
      body ?? 'Please visit the app to see the details',
      tz.TZDateTime.from(
        dateTime,
        tz.local,
      ),
      NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<List<PendingNotificationRequest>> getNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests = await FlutterLocalNotificationsPlugin().pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  static cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();
  static cancel(id) async => await flutterLocalNotificationsPlugin.cancel(id);
}

// Handle background notifications
Future<void> localBackgroundHandler(NotificationResponse data) async {
  try {
    var payloadObj = json.decode(data.payload ?? "{}") as Map? ?? {};
    openNotification(payloadObj);
  } catch (e, stackTrace) {
    FirebaseCrashLogger.nonFatalError(error: e, stackTrace: stackTrace);
  }
}

// Open the notification based on the payload
void openNotification(Map payloadObj) async {
  try {
    if (payloadObj['routes'] != null) {
      String routes = payloadObj['routes'];
      if (payloadObj['id'] != null) {
        routes += "/${payloadObj['id']}";
      }
      AppRoutes.routes.push(routes);
    } else {
      AppRoutes.routes.push(AppRoutesList.homeScreen);
    }
  } catch (e, stackTrace) {
    FirebaseCrashLogger.nonFatalError(error: e, stackTrace: stackTrace);
    AppRoutes.routes.push(AppRoutesList.homeScreen);
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
}
