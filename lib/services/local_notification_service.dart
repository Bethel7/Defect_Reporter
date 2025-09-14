import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/my_reports/domain/notification_list_provider.dart';
import '../features/my_reports/data/notification_model.dart';

class LocalNotificationService {
  bool _enabled = true;
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  BuildContext? _navContext;
  WidgetRef? _ref;

  Future<void> enableNotifications() async {
    _enabled = true;
  }

  Future<void> disableNotifications() async {
    _enabled = false;
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> initialize(BuildContext context, [WidgetRef? ref]) async {
    if (!_enabled) return;
    _navContext = context;
    _ref = ref;
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (_navContext != null) {
          Navigator.of(_navContext!).pushNamed('/notifications');
        }
      },
    );
    // Request notification permissions for iOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
    WidgetRef? ref,
  }) async {
    if (!_enabled) return;
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'General',
          channelDescription: 'General notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _flutterLocalNotificationsPlugin.show(id, title, body, details);

    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: body,
      timestamp: DateTime.now(),
      isRead: false,
    );
    final provider = ref ?? _ref;
    if (provider != null) {
      provider.read(notificationListProvider.notifier).add(notification);
    }
  }
}
