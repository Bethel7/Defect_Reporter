import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_model.dart';

class NotificationListNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationListNotifier() : super([]);

  void add(NotificationModel notification) {
    state = [notification, ...state];
  }

  void markAsRead(String id) {
    state = [
      for (final notif in state)
        if (notif.id == id) notif.copyWith(isRead: true) else notif
    ];
  }
}

final notificationListProvider =
    StateNotifierProvider<NotificationListNotifier, List<NotificationModel>>(
        (ref) => NotificationListNotifier());