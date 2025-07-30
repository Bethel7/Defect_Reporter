import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/settings_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/notification_bell.dart';
import '../../../features/my_reports/domain/notification_count_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer(
              builder: (context, ref, _) {
                 final count = ref.watch(notificationCountProvider);
                    return NotificationBell(
                   notificationCount: count,
                   onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
               },
      );
    },
  ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.accent),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SettingsTile(
              icon: Icons.person,
              label: 'User Profile',
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.settings,
              label: 'General Setting',
              onTap: () => Navigator.pushNamed(context, '/general-setting'),
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.notifications,
              label: 'Notification',
              onTap: () => Navigator.pushNamed(context, '/notification-setting'),
            ),
            const SizedBox(height: 32),
            
            SettingsTile(
              icon: Icons.help_outline,
              label: 'Support',
              onTap: () => Navigator.pushNamed(context, '/support'),
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}