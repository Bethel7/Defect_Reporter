import '../data/notification_model.dart';
import 'notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationModel>> call() async {
    try {
      return await repository.getNotifications();
    } catch (e) {
      // Optionally log error or rethrow a custom Failure
      throw Exception('Failed to fetch notifications: $e');
    }
  }
}
