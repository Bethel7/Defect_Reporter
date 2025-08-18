import 'package:defect_reporter/features/my_reports/presentation/my_reports_page.dart';
import 'package:defect_reporter/features/settings/presentation/support_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/home/home_page.dart';
import 'features/report/presentation/report_form_page.dart';
import 'package:device_preview/device_preview.dart';
import 'features/settings/presentation/settings_page.dart';
import 'features/my_reports/domain/notification_page.dart';
import 'features/profile/profile_page.dart';
import 'features/auth/presentation/forget_password.dart';
import 'features/my_reports/presentation/report_detail_page.dart';
import 'features/report/data/report_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/push_notification_service.dart'; 
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const ProviderScope(child: DefectReporterApp()),
    ),
  );
}

class DefectReporterApp extends ConsumerWidget {
  const DefectReporterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize push notification service
    PushNotificationService().initialize(ref);

    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: 'Defect Reporter',
      theme: AppTheme.lightTheme,
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
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationPage());
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
              builder: (_) => ReportDetailPage(report: report),
            );
          default:
            return null;
        }
      },
    );
  }
}
