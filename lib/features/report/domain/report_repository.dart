import '../data/report_model.dart';

abstract class ReportRepository {
  Future<void> submitReport(ReportModel report);
  Future<List<ReportModel>> getMyReports(String userId);
  Future<void> syncOfflineReports();
}