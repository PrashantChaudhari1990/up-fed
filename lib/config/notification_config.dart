import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app.dart';

class NotificationConfig {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _androidNotificationChannel =
      const AndroidNotificationChannel(
    'mh_notification_channel',
    'MH Notification',
    description: 'This channel use to default notification.',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('mh_notification'),
    enableVibration: true,
    showBadge: true,
  );

  static Future<String?> get fcmToken async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      return null;
    }
  }

  _checkPermission() async {
    try {
      await FirebaseMessaging.instance
          .requestPermission(alert: true, sound: true);
    } catch (e) {
      // Permission request failed - continue without notification permissions
    }
  }

  setupFirebaseMessaging() async {
    await _checkPermission();
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidNotificationChannel);
    }
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
      _handleMessage(message);
    });
  }

  _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null) {
      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidNotificationChannel.id,
                  _androidNotificationChannel.name,
                  priority: Priority.max,
                  channelDescription: _androidNotificationChannel.description,
                  icon: android?.smallIcon ?? '@mipmap/ic_launcher',
                  importance: _androidNotificationChannel.importance,
                  sound: const RawResourceAndroidNotificationSound('mh_notification'),
                  playSound: true),
              iOS: const DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                  presentBanner: true,
                  sound: 'mh_notification.wav')));
    }
  }

  void _handleMessage(RemoteMessage message) {
    final currentContext = MyApp.navigatorKey.currentContext;
    if (currentContext != null) {}
  }
}
