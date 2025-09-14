import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_list_provider.dart';

/// Provides the count of unread notifications, derived from notificationListProvider
/// Provides the count of unread notifications, fetched from backend
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final notifier = ref.read(notificationListProvider.notifier);
  return await notifier.getUnreadCount();
});
