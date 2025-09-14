import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/services/offline_storage_service.dart';
import 'package:defect_reporter/features/report/data/report_model.dart';
import 'dart:io';
import 'package:hive/hive.dart';


void main() {
  group('OfflineStorageService', () {
    late OfflineStorageService service;
    late ReportModel report;

    setUp(() async {
       final tempDir = Directory.systemTemp.createTempSync();
       Hive.init(tempDir.path);

      service = OfflineStorageService();
      report = ReportModel(
        localId: 'local-1',
        title: 'Test',
        description: 'Desc',
        status: 'submitted',
        imageUrl: '',
        timestamp: DateTime.now(),
        locationName: 'Loc',
      );
    });

    test('saveReport and getOfflineReports returns saved report', () async {
      await service.saveReport(report);
      final reports = await service.getOfflineReports();
      expect(
        reports,
        isNotEmpty,
        reason: 'Should return at least one report after saving.',
      );
      expect(
        reports.any((r) => r.localId == report.localId),
        isTrue,
        reason: 'Saved report should be found by localId.',
      );
    });

    test('clearOfflineReports removes all reports', () async {
      await service.saveReport(report);
      await service.clearOfflineReports();
      final reports = await service.getOfflineReports();
      expect(
        reports,
        isEmpty,
        reason: 'All reports should be removed after clearOfflineReports.',
      );
    });

    test('removeReportsByLocalIds removes only specified reports', () async {
      final report2 = ReportModel(
        localId: 'local-2',
        title: 'Test2',
        description: 'Desc2',
        status: 'submitted',
        imageUrl: '',
        timestamp: DateTime.now(),
        locationName: 'Loc2',
      );
      await service.saveReport(report);
      await service.saveReport(report2);
      await service.removeReportsByLocalIds(['local-1']);
      final reports = await service.getOfflineReports();
      expect(
        reports.length,
        1,
        reason: 'Only one report should remain after removing by localId.',
      );
      expect(
        reports.first.localId,
        'local-2',
        reason: 'Remaining report should be the one not removed.',
      );
    });

    test(
      'getOfflineReports returns empty list when no reports saved',
      () async {
        await service.clearOfflineReports();
        final reports = await service.getOfflineReports();
        expect(
          reports,
          isEmpty,
          reason: 'Should return empty list if no reports are saved.',
        );
      },
    );

    test('saveReport handles null and empty localId gracefully', () async {
      final reportNullId = ReportModel(
        localId: null,
        title: 'NullId',
        description: 'Desc',
        status: 'submitted',
        imageUrl: '',
        timestamp: DateTime.now(),
        locationName: 'Loc',
      );
      final reportEmptyId = ReportModel(
        localId: '',
        title: 'EmptyId',
        description: 'Desc',
        status: 'submitted',
        imageUrl: '',
        timestamp: DateTime.now(),
        locationName: 'Loc',
      );
      await service.saveReport(reportNullId);
      await service.saveReport(reportEmptyId);
      final reports = await service.getOfflineReports();
      expect(
        reports.any((r) => r.title == 'NullId'),
        isTrue,
        reason: 'Report with null localId should be saved.',
      );
      expect(
        reports.any((r) => r.title == 'EmptyId'),
        isTrue,
        reason: 'Report with empty localId should be saved.',
      );
    });

    test('replaceAllReports replaces all existing reports', () async {
      await service.saveReport(report);
      final newReport = ReportModel(
        localId: 'local-3',
        title: 'New',
        description: 'DescNew',
        status: 'resolved',
        imageUrl: '',
        timestamp: DateTime.now(),
        locationName: 'LocNew',
      );
      await service.replaceAllReports([newReport]);
      final reports = await service.getOfflineReports();
      expect(
        reports.length,
        1,
        reason: 'Should only have one report after replaceAllReports.',
      );
      expect(
        reports.first.localId,
        'local-3',
        reason: 'Replaced report should match new report localId.',
      );
    });
  });
}
