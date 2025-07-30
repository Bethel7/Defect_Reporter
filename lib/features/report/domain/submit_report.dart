import '../domain/report_repository.dart';
import '../data/report_model.dart';


class SubmitReport {
  final ReportRepository repository;

  SubmitReport(this.repository);

  Future<void> call(ReportModel report) {
    return repository.submitReport(report);
  }
}
