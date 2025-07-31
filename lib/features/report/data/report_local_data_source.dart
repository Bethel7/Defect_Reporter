import 'package:hive/hive.dart';
import 'offline_report.dart';

abstract class ReportLocalDataSource {
  Future<void> cacheReport(OfflineReport report);
  Future<List<OfflineReport>> getCachedReports();
  Future<void> removeCachedReport(OfflineReport report);
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  static const String _boxName = 'offline_reports';

  @override
  Future<void> cacheReport(OfflineReport report) async {
    final box = Hive.box<OfflineReport>(_boxName);
    await box.put(report.id, report);
  }

  @override
  Future<List<OfflineReport>> getCachedReports() async {
    final box = Hive.box<OfflineReport>(_boxName);
    return box.values.toList();
  }

  @override
  Future<void> removeCachedReport(OfflineReport report) async {
    final box = Hive.box<OfflineReport>(_boxName);
    await box.delete(report.id);
  }
}
