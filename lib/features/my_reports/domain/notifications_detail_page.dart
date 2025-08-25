import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import 'notification_list_provider.dart';

class NotificationDetailPage extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mark as read when opened
    ref.read(notificationListProvider.notifier).markAsRead(notification.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Text(
          'Notification Detail',
          style: TextStyles.headlineMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black.withOpacity(0.07), height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        notification.isRead
                            ? Icons.notifications
                            : Icons.notifications_active,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyles.headlineMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    notification.message,
                    style: TextStyles.bodyLarge.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (notification.type != null &&
                      notification.type!.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.black45,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Type: ${notification.type}',
                          style: TextStyles.bodyMedium.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (notification.status != null &&
                      notification.status!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status: ${notification.status}',
                          style: TextStyles.bodyMedium.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (notification.reportId != null &&
                      notification.reportId!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.assignment,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Related Report ID: ${notification.reportId}',
                          style: TextStyles.bodyMedium.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.black38,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Received: ${notification.timestamp}',
                        style: TextStyles.bodyMedium.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
