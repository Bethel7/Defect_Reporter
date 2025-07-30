import 'report_model.dart';

abstract class ReportRemoteDataSource {
  Future<void> submitReport(ReportModel report);
  Future<List<ReportModel>> getMyReports(String userId);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  @override
  Future<void> submitReport(ReportModel report) async {
    // TODO: Implement API call to submit report
    await Future.delayed(const Duration(seconds: 1));
    // Simulate success for now
  }

  @override
  Future<List<ReportModel>> getMyReports(String userId) async {
    // TODO: Implement API call to fetch reports for the user
    await Future.delayed(const Duration(seconds: 1));
    // Return dummy data for now
    return [];
  }
}
