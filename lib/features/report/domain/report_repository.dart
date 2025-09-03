import '../data/report_model.dart';

abstract class ReportRepository {
  Future<void> submitReport(ReportModel report);
  Future<List<ReportModel>> getMyReports(int userId);
  Future<int> syncOfflineReports();
}
