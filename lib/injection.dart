import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/auth_service.dart';
import 'services/location_service.dart';
import 'services/ai_tagging_service.dart';
import 'services/push_notification_service.dart';
import 'services/offline_storage_service.dart';
//import 'services/profile_service.dart';
import 'services/local_notification_service.dart';

// Registering services as providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);
final aiTaggingServiceProvider = Provider<AITaggingService>(
  (ref) => AITaggingService(),
);
final pushNotificationServiceProvider = Provider<PushNotificationService>(
  (ref) => PushNotificationService(),
);
final offlineStorageServiceProvider = Provider<OfflineStorageService>(
  (ref) => OfflineStorageService(),
);
// final profileSServiceProvider = Provider<ProfileService>(
//   (ref) => ProfileService(baseUrl: baseurl),
// );
final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (ref) => LocalNotificationService(),
);
