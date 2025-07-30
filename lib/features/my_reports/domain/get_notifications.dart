import '../data/notification_model.dart';
import 'notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationModel>> call() {
    return repository.getNotifications();
  }
}
