import 'report_repository.dart';

class SyncOfflineReports {
  final ReportRepository repository;

  SyncOfflineReports(this.repository);

  Future<void> call() {
    return repository.syncOfflineReports();
  }
}