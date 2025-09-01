import 'package:hive/hive.dart';
import 'report_model.dart';

abstract class ReportLocalDataSource {
  Future<void> cacheReport(ReportModel report);
  Future<List<ReportModel>> getCachedReports();
  Future<void> clearCachedReports();
  Future<void> replaceAllReports(List<ReportModel> reports);
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  static const String _boxName = 'cached_reports';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  @override
  Future<void> cacheReport(ReportModel report) async {
    final box = await _openBox();
    final reports = await getCachedReports();
    reports.add(report);
    final reportList = reports.map((e) => e.toJson()).toList();
    await box.put('reports', reportList);
  }

  @override
  Future<List<ReportModel>> getCachedReports() async {
    final box = await _openBox();
    final List<dynamic>? reportList = box.get('reports') as List<dynamic>?;
    if (reportList == null) return [];
    return reportList.map((e) => ReportModel.fromJson(e)).toList();
  }

  @override
  Future<void> clearCachedReports() async {
    final box = await _openBox();
    await box.delete('reports');
  }

  @override
  Future<void> replaceAllReports(List<ReportModel> reports) async {
    final box = await _openBox();
    final reportList = reports.map((e) => e.toJson()).toList();
    await box.put('reports', reportList);
  }
}
