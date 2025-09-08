import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:defect_reporter/features/report/presentation/report_form_page.dart';

void main() {
  group('ReportFormPage Widget Tests', () {
    testWidgets(
      'renders app bar, form fields, location selector, image input, and submit button',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: const ReportFormPage()));

        // Check for app bar title
        expect(find.text('New Report'), findsOneWidget);
        // Check for form fields
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        // Check for location selector
        expect(find.text('Location'), findsWidgets);
        // Check for image input area
        expect(find.textContaining('Image'), findsWidgets);
        // Check for submit button
        expect(find.text('Submit'), findsOneWidget);
        // Check for cancel button
        expect(find.text('Cancel'), findsOneWidget);
        // Check for bottom navigation bar
        expect(find.byType(BottomAppBar), findsWidgets);
      },
    );
  });
}
