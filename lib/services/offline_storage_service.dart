import 'package:hive/hive.dart';
import '../features/report/data/report_model.dart';
import '../features/report/data/report_remote_data_source.dart';

class OfflineStorageService {
  /// Syncs all offline reports to the backend using submitMultipleReports.
  /// Clears the cache if successful. Returns true if sync succeeded, false otherwise.
  Future<bool> syncOfflineReports(
    ReportRemoteDataSource remoteDataSource,
  ) async {
    final reports = await getOfflineReports();
    if (reports.isEmpty) return true;
    try {
      final ids = await remoteDataSource.submitMultipleReports(reports);
      if (ids.length == reports.length) {
        await clearOfflineReports();
        return true;
      } else {
        // Partial success, do not clear cache
        return false;
      }
    } catch (e) {
      // Submission failed, keep cache
      print('Sync failed: $e');
      return false;
    }
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
