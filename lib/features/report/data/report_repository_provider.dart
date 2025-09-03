import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/report_repository_impl.dart';
import '../data/report_remote_data_source.dart';
import '../../../services/offline_storage_service.dart';
import '../domain/report_repository.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final remoteDataSource = ReportRemoteDataSourceImpl();
  final offlineStorageService = OfflineStorageService();
  return ReportRepositoryImpl(
    remoteDataSource: remoteDataSource,
    offlineStorageService: offlineStorageService,
  );
});

final userIdProvider = FutureProvider<int?>((ref) async {
  const storage = FlutterSecureStorage();
  final userIdStr = await storage.read(key: 'userId');
  if (userIdStr == null) return null;
  return int.tryParse(userIdStr);
});
