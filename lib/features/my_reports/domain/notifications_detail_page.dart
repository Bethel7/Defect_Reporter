import 'package:flutter/material.dart';
import '../data/notification_model.dart';
import '../../../../core/constants/app_colors.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Detail'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notification.body ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              'Received: ${notification.timestamp}',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}