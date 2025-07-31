import '../domain/report_repository.dart';
import '../data/report_remote_data_source.dart';
import '../data/report_local_data_source.dart';
import '../data/report_model.dart';
import 'offline_report.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final ReportLocalDataSource localDataSource;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> submitReport(ReportModel report) async {
    try {
      await remoteDataSource.submitReport(report);
    } catch (_) {
      // Convert ReportModel to OfflineReport for local caching
      final offlineReport = OfflineReport(
        id: report.id,
        title: report.title,
        description: report.description,
        imagePath: report.imagePath,
        createdAt: report.createdAt,
        location: report.location,
        status: 'pending',
      );
      await localDataSource.cacheReport(offlineReport);
    }
  }

  @override
  Future<List<ReportModel>> getMyReports(String userId) {
    return remoteDataSource.getMyReports(userId);
  }

  @override
  Future<void> syncOfflineReports() async {
    final cachedReports = await localDataSource.getCachedReports();
    for (final offlineReport in cachedReports) {
      try {
        // Convert OfflineReport back to ReportModel for remote submission
        final report = ReportModel(
          id: offlineReport.id,
          title: offlineReport.title,
          description: offlineReport.description,
          location: offlineReport.location,
          status: 'pending',
          imagePath: offlineReport.imagePath,
          createdAt: offlineReport.createdAt,
          imageUrl: '',
        );
        await remoteDataSource.submitReport(report);
        await localDataSource.removeCachedReport(offlineReport);
      } catch (e) {
        print(
          'Failed to sync report with id: ${offlineReport.id}. Error: ${e.toString()}',
        );
      }
    }
  }
}
