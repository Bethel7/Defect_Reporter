import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_model.dart';

class NotificationListNotifier extends StateNotifier<List<NotificationModel>> {
  /// Simulate reloading notifications for pull-to-refresh
  Future<void> refreshNotifications() async {
    // In a real app, fetch from backend or local storage
    await Future.delayed(const Duration(milliseconds: 500));
    state = List<NotificationModel>.from(state);
  }

  NotificationListNotifier() : super([]);

  void add(NotificationModel notification) {
    state = [notification, ...state];
  }

  void markAsRead(String id) {
    state = [
      for (final notif in state)
        if (notif.id == id) notif.copyWith(isRead: true) else notif,
    ];
  }
}

final notificationListProvider =
    StateNotifierProvider<NotificationListNotifier, List<NotificationModel>>(
      (ref) => NotificationListNotifier(),
    );
