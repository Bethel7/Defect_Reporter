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
import 'features/settings/presentation/notification_setting_page.dart';
import 'features/my_reports/domain/notification_page.dart';
import 'features/profile/profile_page.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const ProviderScope(child: DefectReporterApp()),
    ),
  );
}

class DefectReporterApp extends StatelessWidget {
  const DefectReporterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: 'Defect Reporter',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/report-form': (context) => const ReportFormPage(),
        '/my-reports': (context) => const MyReportsPage(),
        '/notification-setting': (context) => const NotificationSettingPage(),
        '/settings': (context) => const SettingsPage(),
        '/notifications': (context) => const NotificationPage(),
        '/support' : (context) => const SupportPage(),
        '/profile' : (context) => const ProfilePage(),
      },
    );
  }
}
