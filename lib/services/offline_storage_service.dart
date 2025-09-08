import 'package:hive/hive.dart';
import '../features/report/data/report_model.dart';
import '../features/report/data/report_remote_data_source.dart';
import 'local_notification_service.dart';

class OfflineStorageService {
  /// Syncs all offline reports to the backend using submitMultipleReports.
  /// Removes only successfully submitted reports from cache. Returns true if all succeeded, false otherwise.
  Future<bool> syncOfflineReports(
    ReportRemoteDataSource remoteDataSource,
  ) async {
    final reports = await getOfflineReports();
    // Only sync reports with a valid localId
    final reportsToSync = reports
        .where((r) => r.localId != null && r.localId!.isNotEmpty)
        .toList();
    if (reportsToSync.isEmpty) return true;
    try {
      final ids = await remoteDataSource.submitMultipleReports(reportsToSync);
      if (ids.isNotEmpty) {
        await removeReportsByLocalIds(
          reportsToSync.map((r) => r.localId!).toList(),
        );
        // Trigger local notification after successful sync
        await LocalNotificationService().showNotification(
          title: 'Reports Synced',
          body: 'Your cached reports have been successfully submitted.',
        );
        // If all reports were synced, return ids.length == reportsToSync.length;
        return ids.length == reportsToSync.length;
      } else {
        // No reports synced, keep cache
        return false;
      }
    } catch (e) {
      // Submission failed, keep cache
      print('Sync failed: $e');
      return false;
    }
  }

  /// Removes reports from offline cache by their localIds
  Future<void> removeReportsByLocalIds(List<String> localIds) async {
    final box = await _getBox();
    final keysToRemove = <dynamic>[];
    for (var entry in box.toMap().entries) {
      final report = entry.value;
      if (report.localId != null && localIds.contains(report.localId)) {
        keysToRemove.add(entry.key);
      }
    }
    await box.deleteAll(keysToRemove);
  }

  static const String _boxName = 'offline_reports';

  Future<Box<ReportModel>> _getBox() async {
    return await Hive.openBox<ReportModel>(_boxName);
  }

  Future<void> saveReport(ReportModel report) async {
    final box = await _getBox();
    await box.add(report);
  }

  Future<List<ReportModel>> getOfflineReports() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> clearOfflineReports() async {
    final box = await _getBox();
    await box.clear();
  }

  Future<void> replaceAllReports(List<ReportModel> reports) async {
    final box = await _getBox();
    await box.clear();
    await box.addAll(reports);
  }
}
