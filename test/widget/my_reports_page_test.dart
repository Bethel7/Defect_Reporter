import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
// TODO: Import your MyReportsPage widget
import 'package:defect_reporter/features/my_reports/presentation/my_reports_page.dart';

void main() {
  group('MyReportsPage Widget Tests', () {
    testWidgets('renders app bar, filters, search bar, and report list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const MyReportsPage()));

      // Check for app bar title
      expect(find.text('Previous Reports'), findsOneWidget);
      // Check for search bar
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search report...'), findsOneWidget);
      // Check for filter dropdowns
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      // Check for report list (ListView)
      expect(find.byType(ListView), findsWidgets);
      // Check for empty state text
      expect(find.text('No reports found.'), findsWidgets);
    });
  });
}
