import 'report_repository.dart';
import '../data/report_model.dart';

class GetMyReports {
  final ReportRepository repository;

  GetMyReports(this.repository);

  Future<List<ReportModel>> call(String userId) {
    return repository.getMyReports(userId);
  }
}