import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:defect_reporter/features/my_reports/presentation/report_detail_page.dart';

void main() {
  group('ReportDetailPage Widget Tests', () {
    testWidgets(
      'renders app bar, report detail fields, status, timestamp, and image section',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const ReportDetailPage(reportId: 'test-id')),
        );

        // Check for app bar title
        expect(find.text('Report Detail'), findsOneWidget);
        // Check for report detail fields
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        expect(find.text('Location'), findsOneWidget);
        // Check for status and timestamp labels
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('Timestamp'), findsOneWidget);
        // Check for image section
        expect(find.text('Image'), findsOneWidget);
        // Check for bottom navigation bar
        expect(find.byType(BottomAppBar), findsWidgets);
      },
    );
  });
}
