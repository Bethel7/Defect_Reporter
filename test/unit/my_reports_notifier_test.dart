import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/features/my_reports/presentation/my_reports_provider.dart';
import 'package:defect_reporter/features/report/data/report_model.dart';
import 'package:defect_reporter/features/report/domain/report_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements ReportRepository {}

void main() {
  group('MyReportsNotifier', () {
    late MockReportRepository mockRepository;
    late MyReportsNotifier notifier;
    const int userId = 123;

    setUp(() {
      mockRepository = MockReportRepository();
      notifier = MyReportsNotifier(mockRepository, userId);
    });

    test('initial state is empty and not loading', () {
      expect(notifier.state.reports, isEmpty);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('loadReports sets reports on success', () async {
      final reports = [
        ReportModel(
          title: 'A',
          description: 'B',
          locationName: 'C',
          status: 'submitted',
          imageUrl: '',
          timestamp: DateTime.now(),
        ),
      ];
      when(
        () => mockRepository.getMyReports(userId),
      ).thenAnswer((_) async => reports);
      final future = notifier.loadReports();
      // Should be loading while awaiting
      expect(notifier.state.isLoading, isTrue);
      await future;
      expect(notifier.state.reports, reports);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('loadReports sets user-friendly error on failure', () async {
      when(
        () => mockRepository.getMyReports(userId),
      ).thenThrow(Exception('fail'));
      final future = notifier.loadReports();
      expect(notifier.state.isLoading, isTrue);
      await future;
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNotNull);
      // Check for user-friendly error (not just raw Exception)
      expect(
        notifier.state.error!.toLowerCase(),
        isNot(contains('exception')),
        reason: 'Error should be user-friendly',
      );
    });

    test('addReport adds a report', () {
      final report = ReportModel(
        title: 'T',
        description: 'D',
        locationName: 'L',
        status: 'submitted',
        imageUrl: '',
        timestamp: DateTime.now(),
      );
      final initialReports = List<ReportModel>.from(notifier.state.reports);
      notifier.addReport(report);
      expect(notifier.state.reports, contains(report));
      // Ensure original list is not mutated
      expect(notifier.state.reports.length, initialReports.length + 1);
    });

    test('refreshReports calls loadReports and updates state', () async {
      final reports = [
        ReportModel(
          title: 'R',
          description: 'Desc',
          locationName: 'Loc',
          status: 'resolved',
          imageUrl: '',
          timestamp: DateTime.now(),
        ),
      ];
      when(
        () => mockRepository.getMyReports(userId),
      ).thenAnswer((_) async => reports);
      final future = notifier.refreshReports();
      expect(notifier.state.isLoading, isTrue);
      await future;
      expect(notifier.state.reports, reports);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('loadReports handles empty reports', () async {
      when(
        () => mockRepository.getMyReports(userId),
      ).thenAnswer((_) async => []);
      await notifier.loadReports();
      expect(notifier.state.reports, isEmpty);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
    });
  });
}
