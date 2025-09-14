import 'package:defect_reporter/features/auth/presentation/login_provider.dart';
import '../../profile/profile_provider.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/theme_mode_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/settings_tile.dart';
import '../../profile/change_password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifications_setting_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void _onThemeChanged(bool isDark) {
    final notifier = ref.read(themeModeProvider.notifier);
    notifier.setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
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
          'Settings',
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
      body: Padding(
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
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      if (!isDark)
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
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.12,
                        ),
                        child: Icon(
                          FontAwesomeIcons.user,
                          size: 28,
                          color: theme.colorScheme.primary,
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
                                color: isDark
                                    ? Colors.grey[700]
                                    : Colors.grey[200],
                              ),
                              error: (e, _) => Text(
                                'User',
                                style:
                                    theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ) ??
                                    TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                              ),
                              data: (profile) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.fullName,
                                    style:
                                        theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ) ??
                                        TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    profile.email,
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                        ) ??
                                        TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        color:
                            theme.iconTheme.color ??
                            theme.colorScheme.onSurface,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Theme Toggle
            Semantics(
              label: 'Theme Mode',
              button: true,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 28),
                child: ListTile(
                  leading: Icon(
                    Icons.brightness_6,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: Consumer(
                    builder: (context, ref, _) {
                      final themeMode = ref.watch(themeModeProvider);
                      return Switch(
                        value: themeMode == ThemeMode.dark,
                        onChanged: _onThemeChanged,
                        activeColor: theme.colorScheme.primary,
                      );
                    },
                  ),
                ),
              ),
            ),
            // Notification Settings Tile
            Semantics(
              label: 'Notification Settings',
              button: true,
              child: SettingsTile(
                icon: FontAwesomeIcons.bell,
                label: 'Notifications',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsSettingPage(),
                  ),
                ),
              ),
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
                    await ref.read(loginProvider.notifier).logout(ref);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout failed: ${e.toString()}')),
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
