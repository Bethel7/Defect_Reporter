import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:defect_reporter/features/report/presentation/cached_reports_page.dart';

void main() {
  group('CachedReportsPage Widget Tests', () {
    testWidgets('renders app bar, empty state, and cached report list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const CachedReportsPage(),
        ),
      );

      // Check for app bar title
      expect(find.text('Cached Reports'), findsOneWidget);
      // Check for empty state icon and text
      expect(find.byIcon(FontAwesomeIcons.folderOpen), findsOneWidget);
      expect(find.text('No cached reports.'), findsOneWidget);
      // Check for cached report list (ListView)
      expect(find.byType(ListView), findsWidgets);
      // Check for bottom navigation bar
      expect(find.byType(BottomAppBar), findsWidgets);
    });
  });
}
