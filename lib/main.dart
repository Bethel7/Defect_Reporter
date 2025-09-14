import 'package:defect_reporter/features/auth/presentation/login_provider.dart';

import 'widgets/offline_snackbar.dart';
import 'dart:async';
import 'features/report/domain/sync_offline_report.dart';
import 'features/report/data/report_repository_impl.dart';
import 'features/report/data/report_remote_data_source.dart';
import 'services/offline_storage_service.dart';

import 'package:defect_reporter/features/my_reports/presentation/my_reports_page.dart';
import 'package:defect_reporter/features/settings/presentation/support_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'features/splash/splash_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/home/home_page.dart';
import 'features/report/presentation/report_form_page.dart';
import 'features/report/presentation/cached_reports_page.dart';
import 'features/settings/presentation/settings_page.dart';
import 'features/my_reports/domain/notification_page.dart';
import 'features/profile/profile_page.dart';
import 'features/auth/presentation/forgot_password.dart';
import 'features/my_reports/presentation/report_detail_page.dart';
import 'features/report/data/report_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/push_notification_service.dart';
import 'services/local_notification_service.dart';
import 'features/settings/presentation/notifications_setting_page.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/reset_password.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  Hive.registerAdapter(ReportModelAdapter());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const ProviderScope(child: DefectReporterApp()));
}

class DefectReporterApp extends ConsumerStatefulWidget {
  const DefectReporterApp({super.key});

  @override
  ConsumerState<DefectReporterApp> createState() => _DefectReporterAppState();
}

class _DefectReporterAppState extends ConsumerState<DefectReporterApp> {
  // Set up your repository and sync use case
  late final ReportRepositoryImpl _repository;
  late final SyncOfflineReports _syncOfflineReports;
  late OfflineSyncManager _offlineSyncManager;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize repository and sync use case
  //   _repository = ReportRepositoryImpl(
  //     remoteDataSource: ReportRemoteDataSourceImpl(),
  //     offlineStorageService: OfflineStorageService(),
  //   );
  //   _syncOfflineReports = SyncOfflineReports(_repository);

  //   // Initialize local notifications
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     LocalNotificationService().initialize(context, ref);
  //     // Start global offline sync manager with ref
  //     _offlineSyncManager = OfflineSyncManager(_syncOfflineReports, ref);
  //     _offlineSyncManager.start();
  //   });
  // }
 @override
void initState() {
  super.initState();

  // Restore logged-in user from secure storage
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final loginNotifier = ref.read(loginProvider.notifier);
    await loginNotifier.restoreUserSession(ref);

    // Initialize local notifications
    LocalNotificationService().initialize(context, ref);

    // Start global offline sync manager with ref
    _offlineSyncManager = OfflineSyncManager(_syncOfflineReports, ref);
    _offlineSyncManager.start();
  });

  // Initialize repository and sync use case
  _repository = ReportRepositoryImpl(
    remoteDataSource: ReportRemoteDataSourceImpl(),
    offlineStorageService: OfflineStorageService(),
  );
  _syncOfflineReports = SyncOfflineReports(_repository);
}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize push notification service
    PushNotificationService().initialize(ref);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Defect Reporter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),
      scaffoldMessengerKey: OfflineSnackbar.key,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashPage());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/report-form':
            return MaterialPageRoute(builder: (_) => const ReportFormPage());
          case '/my-reports':
            return MaterialPageRoute(builder: (_) => const MyReportsPage());
          case '/cached-reports':
            return MaterialPageRoute(builder: (_) => const CachedReportsPage());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationPage());
          case '/notifications-settings':
            return MaterialPageRoute(
              builder: (_) => const NotificationsSettingPage(),
            );
          case '/forgot-password':
            return MaterialPageRoute(
              builder: (_) => const ForgotPasswordPage(),
            );
          case '/support':
            return MaterialPageRoute(builder: (_) => const SupportPage());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfilePage());
          case '/report-detail':
            final report = settings.arguments as ReportModel;
            return MaterialPageRoute(
              builder: (_) =>
                  ReportDetailPage(report: report),
            );
          case '/reset-password':
            return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
          default:
            return null;
        }
      },
    );
  }
}
