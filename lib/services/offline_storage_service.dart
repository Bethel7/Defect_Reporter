import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/report/data/report_model.dart';

class OfflineStorageService {
  static const String _offlineReportsKey = 'offline_reports';

  Future<void> saveReport(ReportModel report) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> reportsJson =
        prefs.getStringList(_offlineReportsKey) ?? [];
    reportsJson.add(jsonEncode(report.toJson()));
    await prefs.setStringList(_offlineReportsKey, reportsJson);
  }

  Future<List<ReportModel>> getOfflineReports() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> reportsJson =
        prefs.getStringList(_offlineReportsKey) ?? [];
    return reportsJson
        .map((jsonStr) => ReportModel.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  Future<void> clearOfflineReports() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_offlineReportsKey);
  }
}