import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../features/my_reports/domain/notification_count_provider.dart';

class NotificationBell extends ConsumerWidget {
  final VoidCallback? onPressed;
  const NotificationBell({super.key, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationCount = ref.watch(unreadNotificationCountProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Semantics(
      label: 'Notifications',
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircleAvatar(
              backgroundColor: colorScheme.primary,
              radius: 18,
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed:
                    onPressed ??
                    () => Navigator.pushNamed(context, '/notifications'),
                tooltip: 'Notifications',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          if (notificationCount > 0)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '$notificationCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
