import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "Mr. Berhanu";
    final String userEmail = "Berhanu@ethiopianairlines.com";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        title: Semantics(
          label: 'Settings Page',
          header: true,
          child: const Text(
            'Settings',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
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
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                  color: AppColors.primary.withOpacity(0.07),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            size: 36,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userEmail,
                                style: const TextStyle(
                                 color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
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
                icon: Icons.lock_outline,
                label: 'Change Password',
                onTap: () => Navigator.pushNamed(context, '/change-password'),
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              label: 'Support and Frequently Asked Questions',
              button: true,
              child: SettingsTile(
                icon: Icons.help_outline,
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
                icon: Icons.logout,
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
