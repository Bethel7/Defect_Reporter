import 'package:defect_reporter/features/my_reports/domain/notification_hive_service.dart';
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

  /// Fetch notifications from backend and store in Hive
  Future<void> fetchNotifications({bool unreadOnly = false}) async {
    final response = await _dio.get(
      '/api/Notifications/user/$userId',
      queryParameters: {'unreadOnly': unreadOnly},
    );
    final data = response.data['data'];
    List<NotificationModel> backendNotifications = [];
    if (data is List) {
      backendNotifications = data
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    }
    // Save backend notifications to Hive
    final hiveService = NotificationHiveService();
    await hiveService.saveNotifications(backendNotifications);
    // Merge with local/push notifications
    final localNotifications = await hiveService.getNotifications();
    // Remove duplicates by id
    final allNotifications = <String, NotificationModel>{};
    for (var n in [...backendNotifications, ...localNotifications, ...state]) {
      allNotifications[n.id] = n;
    }
    state = allNotifications.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Mark a notification as read in backend and update state
  Future<void> markAsRead(String id) async {
    await _dio.post('/api/Notifications/$id/read');
    state = [
      for (final notif in state)
        if (notif.id == id) notif.copyWith(isRead: true) else notif,
    ];
  }

  // /// Mark all notifications as read in backend and update state
  // Future<void> markAllAsRead() async {
  //   await _dio.post('/api/Notifications/user/$userId/read-all');
  //   state = [for (final notif in state) notif.copyWith(isRead: true)];
  // }

  /// Get unread count from backend and local notifications
  Future<int> getUnreadCount() async {
    final response = await _dio.get(
      '/api/Notifications/user/$userId/unread-count',
    );
    final backendCount = response.data['unreadCount'];
    int backendUnread = 0;
    if (backendCount is int) backendUnread = backendCount;
    if (backendCount is String) backendUnread = int.tryParse(backendCount) ?? 0;
    // Add local/push notifications unread count
    final hiveService = NotificationHiveService();
    final localNotifications = await hiveService.getNotifications();
    final localUnread = localNotifications.where((n) => !n.isRead).length;
    return backendUnread + localUnread;
  }

  /// Add a notification locally
  void add(NotificationModel notification) async {
    final hiveService = NotificationHiveService();
    final current = await hiveService.getNotifications();
    await hiveService.saveNotifications([notification, ...current]);
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
  return user?.id ?? 0;
});

final notificationListProvider =
    StateNotifierProvider<NotificationListNotifier, List<NotificationModel>>(
      (ref) => NotificationListNotifier(
        dio: ref.read(dioProvider),
        userId: ref.read(userIdProvider),
      ),
    );
