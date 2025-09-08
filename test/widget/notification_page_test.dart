import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:defect_reporter/features/my_reports/domain/notification_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  group('NotificationPage Widget Tests', () {
    testWidgets(
      'renders app bar, empty state, FontAwesome bell icon, and notification list',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: const NotificationPage()));

        // Check for app bar title
        expect(find.text('Notifications'), findsOneWidget);
        // Check for empty state text
        expect(find.text('No notifications yet'), findsWidgets);
        expect(
          find.textContaining('Your notifications will appear here'),
          findsWidgets,
        );
        // Check for notification list (ListView)
        expect(find.byType(ListView), findsWidgets);
        // Check for FontAwesome bell icon (bellSlash for empty state)
        expect(find.byIcon(FontAwesomeIcons.bellSlash), findsOneWidget);
        // Check for notification badge (if any notifications)
        // TODO: Add test for notification badge when notifications exist
      },
    );
  });
}
