import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePopupMenu extends StatelessWidget {
  final void Function(int)? onSelected;

  const ProfilePopupMenu({super.key, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'Profile menu',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected:
          onSelected ??
          (value) {
            if (value == 0) {
              Navigator.pushNamed(context, '/profile');
            } else if (value == 1) {
              Navigator.pushNamed(context, '/settings');
            } else if (value == 2) {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.user, color: AppColors.accent, size: 20),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.gear, color: AppColors.accent, size: 20),
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
                color: AppColors.accent,
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
