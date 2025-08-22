import '../domain/report_repository.dart';
import '../data/report_remote_data_source.dart';
import '../../../services/offline_storage_service.dart';
import 'report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final OfflineStorageService offlineStorageService;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.offlineStorageService,
  });

  @override
  Future<void> submitReport(ReportModel report) async {
    try {
      await remoteDataSource.submitReport(report);
    } catch (_) {
      await offlineStorageService.saveReport(report);
    }
  }

  @override
  Future<List<ReportModel>> getMyReports(String userId) {
    return remoteDataSource.getMyReports(userId);
  }

  @override
  Future<int> syncOfflineReports() async {
    final cachedReports = await offlineStorageService.getOfflineReports();
    int syncedCount = 0;
    final List<ReportModel> failedToSync = [];
    for (final report in cachedReports) {
      try {
        await remoteDataSource.submitReport(report);
        syncedCount++;
      } catch (_) {
        failedToSync.add(report);
      }
    }
    // Only keep failed reports in offline storage
    if (failedToSync.isEmpty) {
      await offlineStorageService.clearOfflineReports();
    } else {
      await offlineStorageService.replaceAllReports(failedToSync);
    }
    return syncedCount;
  }
}
