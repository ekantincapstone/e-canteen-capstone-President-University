import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApiMessaging {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // request permission
    await _messaging.requestPermission();

    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        await _handleForegroundNotification(message.notification!);
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    // Background message handling
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    final String? title = message.notification?.title;
    final String? body = message.notification?.body;

    if (title != null && body != null) {
      await _showNotification(title, body);
    }
  }

  static Future<void> _handleForegroundNotification(RemoteNotification notification) async {
    final String? title = notification.title;
    final String? body = notification.body;
    print('asndasjdjsadsa');
    if (title != null && body != null) {
      print('BERHASIOLL');
      await _showNotification(title, body);
    }
  }

  static Future<void> _showNotification(String title, String body) async {
    // Create a NotificationDetails instance specifying the Android and iOS notification settings
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    final DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    // Show the notification
    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Title
      body, // Body
      platformChannelSpecifics, // Notification details
      payload: 'item x', // Payload
    );
  }

  static Future<String?> getToken() async {
    String? token = await _messaging.getToken();
    return token;
  }
}
