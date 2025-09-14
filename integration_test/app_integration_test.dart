import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:defect_reporter/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('App launches and shows login page', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('Ethiopian Airlines'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Login flow: enter credentials and navigate to dashboard', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      // Enter employee ID
      await tester.enterText(find.bySemanticsLabel('EmployeeID'), 'testuser');
      // Enter password
      await tester.enterText(find.bySemanticsLabel('Password'), 'password123');
      // Tap Login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      // Verify navigation to dashboard
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.textContaining('Hello,'), findsOneWidget);
    });

    testWidgets('Report submission: fill form and submit', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      // Navigate to New Report page
      await tester.tap(find.text('New Report'));
      await tester.pumpAndSettle();
      // Fill in report fields
      await tester.enterText(
        find.bySemanticsLabel('Report Title Input'),
        'Test Report',
      );
      await tester.enterText(
        find.bySemanticsLabel('Report Description Input'),
        'This is a test report.',
      );
      // Select location (assume dropdown or selector)
      await tester.tap(find.text('Location'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Addis Ababa'));
      await tester.pumpAndSettle();
      // Tap Submit button
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      // Verify confirmation page
      expect(find.text('Submission Successful!'), findsOneWidget);
      expect(find.textContaining('Thank you for reporting'), findsOneWidget);
    });
    testWidgets('Offline report: submit while offline and verify cached', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      // Simulate offline mode (mock or override network checker)
      // This step depends on your implementation; you may need to inject a mock provider
      // Navigate to New Report page
      await tester.tap(find.text('New Report'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.bySemanticsLabel('Report Title Input'),
        'Offline Report',
      );
      await tester.enterText(
        find.bySemanticsLabel('Report Description Input'),
        'This report is offline.',
      );
      await tester.tap(find.text('Location'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Addis Ababa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      // Verify cached report confirmation page
      expect(find.text('Report Saved Offline'), findsOneWidget);
      expect(
        find.textContaining('Your report has been saved locally'),
        findsOneWidget,
      );
      // Go to cached reports page
      await tester.tap(find.text('Cached Reports'));
      await tester.pumpAndSettle();
      expect(find.text('Cached Reports'), findsOneWidget);
      expect(find.text('Offline'), findsWidgets);
    });
  });
}

