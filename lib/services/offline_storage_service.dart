import '../features/report/data/report_model.dart';

class OfflineStorageService {
  Future<void> saveReport(ReportModel report) async {
    // Save report locally (e.g., SQLite, shared_preferences)
  }

  Future<List<ReportModel>> getOfflineReports() async {
    // Retrieve locally saved reports
    return [];
  }

  Future<void> clearOfflineReports() async {
    // Clear local storage
  }
}