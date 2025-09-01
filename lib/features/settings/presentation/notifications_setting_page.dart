import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/notification_toggle_tile.dart';
import '../../../services/local_notification_service.dart';
import '../../../services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettingPage extends ConsumerStatefulWidget {
  const NotificationsSettingPage({super.key});

  @override
  ConsumerState<NotificationsSettingPage> createState() =>
      _NotificationsSettingPageState();
}

class _NotificationsSettingPageState
    extends ConsumerState<NotificationsSettingPage> {
  bool _pushNotificationsEnabled = true;
  bool _localNotificationsEnabled = true;
  bool _loadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotificationsEnabled =
          prefs.getBool('push_notifications_enabled') ?? true;
      _localNotificationsEnabled =
          prefs.getBool('local_notifications_enabled') ?? true;
      _loadingPrefs = false;
    });
  }

  Future<void> _setPushNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications_enabled', value);
    setState(() => _pushNotificationsEnabled = value);
    // Enable or disable push notifications
    if (value) {
      await PushNotificationService().enablePushNotifications();
    } else {
      await PushNotificationService().disablePushNotifications();
    }
  }

  Future<void> _setLocalNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('local_notifications_enabled', value);
    setState(() => _localNotificationsEnabled = value);
    // Enable or disable local notifications
    if (value) {
      await LocalNotificationService().enableNotifications();
    } else {
      await LocalNotificationService().disableNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Text(
          'Notification Settings',
          style:
              theme.textTheme.titleLarge?.copyWith(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ) ??
              TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.07),
            height: 1,
          ),
        ),
      ),
      body: _loadingPrefs
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  NotificationToggleTile(
                    icon: FontAwesomeIcons.bell,
                    label: 'Push Notifications',
                    value: _pushNotificationsEnabled,
                    onChanged: _setPushNotificationsEnabled,
                    description:
                        'Receive updates and alerts from Ethiopian Airlines.',
                  ),
                  const SizedBox(height: 12),
                  NotificationToggleTile(
                    icon: FontAwesomeIcons.clock,
                    label: 'Local Notifications',
                    value: _localNotificationsEnabled,
                    onChanged: _setLocalNotificationsEnabled,
                    description: 'Get offline alerts on your device.',
                  ),
                ],
              ),
            ),
    );
  }
}
