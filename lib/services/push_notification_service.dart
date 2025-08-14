import 'package:firebase_messaging/firebase_messaging.dart';
import '../features/my_reports/domain/notification_list_provider.dart';
import '../features/my_reports/domain/notification_count_provider.dart';
import '../features/my_reports/data/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize(WidgetRef ref) async {
    // Request notification permissions (especially important for iOS)
    await _messaging.requestPermission();

    // Optionally get the FCM token for this device
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notif = NotificationModel(
        id: message.messageId ?? DateTime.now().toIso8601String(),
        title: message.notification?.title ?? 'Notification',
        message: message.notification?.body ?? '',
        timestamp: DateTime.now(),
        isRead: false,
      );
      ref.read(notificationListProvider.notifier).add(notif);
      ref.read(notificationCountProvider.notifier).state++;
      print('Received a foreground message: ${message.data}');
    });

    // Handle background & terminated state messages (optional)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification caused app to open: ${message.data}');
      // Handle navigation or other logic here
    });
  }
}