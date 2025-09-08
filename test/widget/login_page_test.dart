import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:defect_reporter/features/auth/presentation/login_page.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets(
      'renders logo, airline name, welcome text, form fields, and login button',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: const LoginPage()));

        // Check for logo image
        expect(find.byType(Image), findsOneWidget);
        // Check for airline name
        expect(find.text('Ethiopian Airlines'), findsOneWidget);
        // Check for welcome text
        expect(find.text('Welcome to issue\nReporter'), findsOneWidget);
        // Check for EmployeeID and Password fields
        expect(find.text('EmployeeID'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        // Check for Forgot Password button
        expect(find.text('Forgot Password?'), findsOneWidget);
        // Check for Login button
        expect(find.text('Login'), findsOneWidget);
      },
    );
  });
}
