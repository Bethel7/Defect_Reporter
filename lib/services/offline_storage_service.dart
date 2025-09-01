import 'package:hive/hive.dart';
import '../features/report/data/report_model.dart';

class OfflineStorageService {
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