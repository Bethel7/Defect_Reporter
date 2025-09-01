import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/services/offline_storage_service.dart';
import 'package:defect_reporter/features/report/data/report_model.dart';
import 'dart:io';

void main() {
  group('OfflineStorageService', () {
    late OfflineStorageService service;
    late ReportModel report;

    setUp(() {
      service = OfflineStorageService();
      report = ReportModel(
        id: '1',
        title: 'Test',
        description: 'Desc',
        location: 'Loc',
        status: 'submitted',
        imageUrl: '',
        timestamp: DateTime.now(),
      );
    });

    test('saveReport and getOfflineReports', () async {
      await service.saveReport(report);
      final reports = await service.getOfflineReports();
      expect(reports, isNotEmpty);
      expect(reports.any((r) => r.id == report.id), isTrue);
    });

    test('clearOfflineReports removes all reports', () async {
      await service.saveReport(report);
      await service.clearOfflineReports();
      final reports = await service.getOfflineReports();
      expect(reports, isEmpty);
    });
  });
}
