import 'package:firebase_messaging/firebase_messaging.dart';
import '../features/my_reports/domain/notification_list_provider.dart';
import '../features/my_reports/data/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _enabled = true;

  Future<void> initialize(WidgetRef ref) async {
    // Request notification permissions
    await _messaging.requestPermission();

    //  get the FCM token for this device
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (!_enabled) return;
      final notif = NotificationModel(
        id: message.messageId ?? DateTime.now().toIso8601String(),
        title: message.notification?.title ?? 'Notification',
        message: message.notification?.body ?? '',
        timestamp: DateTime.now(),
        isRead: false,
      );
      ref.read(notificationListProvider.notifier).add(notif);
      print('Received a foreground message: ${message.data}');
    });

    // Handle background & terminated state messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification caused app to open: ${message.data}');
      // Handle navigation or other logic here
    });
  }

  Future<void> enablePushNotifications() async {
    _enabled = true;
    // re-request permissions or subscribe to topics here
    print('Push notifications enabled');
  }

  Future<void> disablePushNotifications() async {
    _enabled = false;
    // unsubscribe from topics or revoke permissions here
    print('Push notifications disabled');
  }
}
