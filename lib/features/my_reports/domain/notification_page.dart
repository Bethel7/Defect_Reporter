import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'notification_repository.dart';
import '../data/notification_model.dart';
import 'notifications_detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = DummyNotificationRepository().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Text(
            'Notifications',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            // No notifications UI
            return Center(
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
            );
          }
          // Notifications list UI
          return ListView.separated(
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
                            builder: (_) => NotificationDetailPage(notification: notif),
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
          );
        },
      ),
    );
  }
}
