import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_model.dart';
import 'package:dio/dio.dart';
import '../../../api_client.dart';
import '../../auth/presentation/login_provider.dart';

class NotificationListNotifier extends StateNotifier<List<NotificationModel>> {
  final Dio _dio;
  final int userId;

  NotificationListNotifier({required Dio dio, required this.userId})
    : _dio = dio,
      super([]);

  /// Fetch notifications from backend
  Future<void> fetchNotifications({bool unreadOnly = false}) async {
    final response = await _dio.get(
      '/api/notifications/user/$userId',
      queryParameters: {'unreadOnly': unreadOnly},
    );
    final data = response.data['Data'] as List?;
    if (data != null) {
      final notifications = data
          .map((json) => NotificationModel.fromJson(json))
          .toList();
      state = notifications;
    }
  }

  /// Mark a notification as read in backend and update state
  Future<void> markAsRead(String id) async {
    await _dio.post('/api/notifications/$id/read');
    state = [
      for (final notif in state)
        if (notif.id == id) notif.copyWith(isRead: true) else notif,
    ];
  }

  /// Mark all notifications as read in backend and update state
  Future<void> markAllAsRead() async {
    await _dio.post('/api/notifications/user/$userId/read-all');
    state = [for (final notif in state) notif.copyWith(isRead: true)];
  }

  /// Get unread count from backend
  Future<int> getUnreadCount() async {
    final response = await _dio.get(
      '/api/notifications/user/$userId/unread-count',
    );
    return response.data['UnreadCount'] as int? ?? 0;
  }

  /// Add a notification locally (for push/local notifications)
  void add(NotificationModel notification) {
    state = [notification, ...state];
  }

  /// Replace all notifications (for initial fetch)
  void setAll(List<NotificationModel> notifications) {
    state = notifications;
  }

  /// Simulate refresh (for pull-to-refresh, just refetch)
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}

final dioProvider = Provider<Dio>((ref) {
  return ApiClient().dio;
});

// Use your real user provider here

final userIdProvider = Provider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.userId ?? 0;
});

final notificationListProvider =
    StateNotifierProvider<NotificationListNotifier, List<NotificationModel>>(
      (ref) => NotificationListNotifier(
        dio: ref.read(dioProvider),
        userId: ref.read(userIdProvider),
      ),
    );
