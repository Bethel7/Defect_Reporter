import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import 'notifications_detail_page.dart';
import 'notification_list_provider.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationListProvider);

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
          label: 'Notifications Page',
          header: true,
          child: const Text(
            'Notifications',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'No notifications icon',
                    child: Icon(
                      Icons.notifications_none,
                      size: 80,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    label: 'No notifications yet',
                    child: Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label:
                        "Your notifications will appear here once you've received them.",
                    child: Text(
                      "Your notifications will appear here once you've received them.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Semantics(
                  label:
                      '${notif.title}, ${notif.isRead ? "Read" : "Unread"} notification',
                  button: true,
                  child: Material(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NotificationDetailPage(notification: notif),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              notif.isRead
                                  ? Icons.notifications
                                  : Icons.notifications_active,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                notif.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}