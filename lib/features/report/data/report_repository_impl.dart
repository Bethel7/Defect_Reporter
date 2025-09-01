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
      // Use the unified endpoint for single report
      final ids = await remoteDataSource.submitReports([report]);
      if (ids.isEmpty) {
        // Not accepted by backend, save offline
        await offlineStorageService.saveReport(report);
      }
    } catch (e, st) {
      // Log error for debugging/analytics
      print('Failed to submit report remotely: $e\n$st');
      await offlineStorageService.saveReport(report);
    }
  }

  @override
  Future<List<ReportModel>> getMyReports(String userId) async {
    try {
      final remoteReports = await remoteDataSource.getMyReports(userId);
      final offlineReports = await offlineStorageService.getOfflineReports();
      // Merge: show offline (pending) reports first, then remote
      return [...offlineReports, ...remoteReports];
    } catch (e, st) {
      // Log error and fallback to offline reports only
      print('Failed to fetch remote reports: $e\n$st');
      return await offlineStorageService.getOfflineReports();
    }
  }

  @override
  Future<int> syncOfflineReports() async {
    final cachedReports = await offlineStorageService.getOfflineReports();
    if (cachedReports.isEmpty) return 0;
    try {
      // Use the unified endpoint for batch submission
      final ids = await remoteDataSource.submitReports(cachedReports);
      // Only remove reports that were successfully sent (matched by id)
      final failed = <ReportModel>[];
      for (final report in cachedReports) {
        if (!ids.contains(report.id)) {
          failed.add(report);
        }
      }
      if (failed.isEmpty) {
        await offlineStorageService.clearOfflineReports();
      } else {
        await offlineStorageService.replaceAllReports(failed);
      }
      return ids.length;
    } catch (e, st) {
      // Log error for failed sync
      print('Failed to sync offline reports: $e\n$st');
      // Keep all reports in offline storage
      return 0;
    }
  }
}
