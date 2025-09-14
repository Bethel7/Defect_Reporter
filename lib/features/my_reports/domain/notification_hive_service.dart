import 'package:hive/hive.dart';
import '../data/notification_model.dart';

class NotificationHiveService {
  static const String boxName = 'notificationsBox';

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final box = await Hive.openBox(boxName);
    await box.put(
      'notifications',
      notifications.map((n) => n.toJson()).toList(),
    );
  }

  Future<List<NotificationModel>> getNotifications() async {
    final box = await Hive.openBox(boxName);
    final data = box.get('notifications');
    if (data == null) return [];
    return List<NotificationModel>.from(
      (data as List).map((json) => NotificationModel.fromJson(json)),
    );
  }
}
