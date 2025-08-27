import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/presentation/login_provider.dart';
import '../../../services/auth_service.dart';

class ProfilePopupMenu extends ConsumerWidget {
  final void Function(int)? onSelected;

  const ProfilePopupMenu({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return PopupMenuButton<int>(
      tooltip: 'Profile menu',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected:
          onSelected ??
          (value) async {
            if (value == 0 && user != null) {
              Navigator.pushNamed(context, '/profile');
            } else if (value == 1) {
              Navigator.pushNamed(context, '/settings');
            } else if (value == 2) {
              try {
                final authService = AuthService();
                await authService.logout();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
                return;
              }
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.user, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.gear, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
      child: Semantics(
        label: 'Open profile menu',
        button: true,
        child: CircleAvatar(
          backgroundColor: AppColors.accent,
          child: Icon(FontAwesomeIcons.user, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
