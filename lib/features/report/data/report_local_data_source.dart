import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'report_model.dart';

abstract class ReportLocalDataSource {
  Future<void> cacheReport(ReportModel report);
  Future<List<ReportModel>> getCachedReports();
  Future<void> clearCachedReports();
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  static const String _cacheKey = 'CACHED_REPORTS';

  @override
  Future<void> cacheReport(ReportModel report) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = await getCachedReports();
    reports.add(report);
    final encoded = jsonEncode(reports.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, encoded);
  }

  @override
  Future<List<ReportModel>> getCachedReports() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => ReportModel.fromJson(e)).toList();
  }

  @override
  Future<void> clearCachedReports() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}