import '../../../services/auth_service.dart';
import '../../profile/profile_provider.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/settings_tile.dart';
import '../../profile/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/notification_toggle_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
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
    // TODO: Add logic to subscribe/unsubscribe from push notifications
  }

  Future<void> _setLocalNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('local_notifications_enabled', value);
    setState(() => _localNotificationsEnabled = value);
    // TODO: Add logic to enable/disable local notifications
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Text(
          'Settings',
          style: TextStyles.headlineMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loadingPrefs
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // User Info Card
                  Semantics(
                    label: 'User Information. Tap to view or edit profile.',
                    button: true,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.12,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.user,
                                size: 28,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  profileAsync.when(
                                    loading: () => Container(
                                      height: 18,
                                      width: 80,
                                      color: Colors.grey[200],
                                    ),
                                    error: (e, _) => Text(
                                      'User',
                                      style: TextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    data: (profile) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.fullName,
                                          style: TextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          profile.email,
                                          style: TextStyles.bodyMedium.copyWith(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              FontAwesomeIcons.chevronRight,
                              color: AppColors.text,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Notification toggles
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
                  const SizedBox(height: 28),
                  // Settings Tiles
                  Semantics(
                    label: 'Change Password',
                    button: true,
                    child: SettingsTile(
                      icon: FontAwesomeIcons.lock,
                      label: 'Change Password',
                      onTap: () => showChangePasswordSheet(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    label: 'Support and Contact',
                    button: true,
                    child: SettingsTile(
                      icon: FontAwesomeIcons.circleQuestion,
                      label: 'Support',
                      onTap: () => Navigator.pushNamed(context, '/support'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Logout
                  Semantics(
                    label: 'Logout',
                    button: true,
                    child: SettingsTile(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      label: 'Logout',
                      onTap: () async {
                        try {
                          final authService = AuthService();
                          await authService.logout();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Logout failed: ${e.toString()}'),
                            ),
                          );
                          return;
                        }
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
