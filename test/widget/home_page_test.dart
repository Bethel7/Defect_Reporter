import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:defect_reporter/features/home/home_page.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets(
      'renders dashboard title, summary cards, welcome text, and recent submissions',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: const HomePage()));

        // Check for dashboard title
        expect(find.text('Dashboard'), findsOneWidget);
        // Check for greeting ("Hello, ...")
        expect(find.textContaining('Hello,'), findsOneWidget);
        // Check for welcome text
        expect(find.textContaining('Welcome back!'), findsOneWidget);
        // Check for summary cards
        expect(find.text('Total Reports'), findsOneWidget);
        expect(find.text('In Progress'), findsOneWidget);
        expect(find.text('Resolved'), findsOneWidget);
        // Check for recent submissions section
        expect(find.text('Recent Submissions'), findsOneWidget);
        // Check for notification bell icon
        expect(find.byIcon(Icons.notifications), findsOneWidget);
      },
    );
  });
}
