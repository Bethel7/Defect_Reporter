import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/presentation/login_provider.dart';


class ProfilePopupMenu extends ConsumerWidget {
  final void Function(int)? onSelected;

  const ProfilePopupMenu({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return PopupMenuButton<int>(
      tooltip: 'Profile menu',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.cardColor,
      onSelected:
          onSelected ??
          (value) async {
            if (value == 0 && user != null) {
              Navigator.pushNamed(context, '/profile');
            } else if (value == 1) {
              Navigator.pushNamed(context, '/settings');
            } else if (value == 2) {
              try {
                await ref.read(loginProvider.notifier).logout(ref);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout failed: \\${e.toString()}'),
                    backgroundColor: colorScheme.primary,
                  ),
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
            children: [
              Icon(FontAwesomeIcons.user, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Profile',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(FontAwesomeIcons.gear, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Settings',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Logout',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Semantics(
        label: 'Open profile menu',
        button: true,
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircleAvatar(
            backgroundColor: colorScheme.primary,
            radius: 18,
            child: Icon(FontAwesomeIcons.user, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
