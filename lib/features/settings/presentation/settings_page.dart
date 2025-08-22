import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/settings_tile.dart';
import '../../profile/change_password.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "Mr. Berhanu";
    final String userEmail = "Berhanu@ethiopianairlines.com";

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
                        backgroundColor: AppColors.primary.withOpacity(0.12),
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
                            Text(
                              userName,
                              style: TextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyles.bodyMedium.copyWith(
                                color: Colors.black54,
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
              label: 'Support and Frequently Asked Questions',
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
                onTap: () {
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
