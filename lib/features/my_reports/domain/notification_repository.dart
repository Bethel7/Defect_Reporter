import '../data/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications();
}

class DummyNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      NotificationModel(
        id: '1',
        title: 'Report Status Updated',
        message: 'Your report "Broken seat" is now being processed.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Report Resolved',
        message: 'Your report "Faulty air conditioner" has been resolved.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
  
  ];
}
}
  