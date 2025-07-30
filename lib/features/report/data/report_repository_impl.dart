import '../domain/report_repository.dart';
import '../data/report_remote_data_source.dart';
import '../data/report_local_data_source.dart';
import '../data/report_model.dart';


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
      await localDataSource.cacheReport(report);
    }
  }

  @override
  Future<List<ReportModel>> getMyReports(String userId) {
    return remoteDataSource.getMyReports(userId);
  }

  @override
  Future<void> syncOfflineReports() async {
    final cachedReports = await localDataSource.getCachedReports();
    for (final report in cachedReports) {
      await remoteDataSource.submitReport(report);
    }
    await localDataSource.clearCachedReports();
  }
}
