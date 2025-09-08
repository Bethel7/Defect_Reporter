import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:defect_reporter/features/settings/presentation/settings_page.dart';
import 'package:defect_reporter/features/profile/profile_page.dart';

void main() {
  group('SettingsPage Widget Tests', () {
    testWidgets('renders app bar, user info, theme switch, and logout button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const SettingsPage()));

      // Check for app bar title
      expect(find.text('Settings'), findsOneWidget);
      // Check for user info card
      expect(find.byType(CircleAvatar), findsWidgets);
      // Check for theme switch
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      // Check for logout button
      expect(find.text('Logout'), findsOneWidget);
    });
  });

  group('ProfilePage Widget Tests', () {
    testWidgets('renders app bar, profile info, and info items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const ProfilePage()));

      // Check for app bar title
      expect(find.text('User Profile'), findsOneWidget);
      // Check for profile avatar
      expect(find.byType(CircleAvatar), findsOneWidget);
      // Check for profile info items
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Employee ID'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Role'), findsOneWidget);
    });
  });
}
