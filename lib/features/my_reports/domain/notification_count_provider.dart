import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_list_provider.dart';

/// Provides the count of unread notifications, derived from notificationListProvider
final unreadNotificationCountProvider = Provider<int>((ref) {
	final list = ref.watch(notificationListProvider);
	return list.where((n) => !n.isRead).length;
});