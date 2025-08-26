import 'report_repository.dart';
import '../../../core/utils/network_checker.dart';
import '../../../widgets/offline_snackbar.dart';
import '../../../core/utils/helpers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/local_notification_service.dart';
import '../../my_reports/presentation/my_reports_provider.dart';

class SyncOfflineReports {
  final ReportRepository repository;

  SyncOfflineReports(this.repository);

  Future<int> call() {
    return repository.syncOfflineReports();
  }
}

class OfflineSyncManager {
  final SyncOfflineReports syncOfflineReports;
  final WidgetRef ref;
  bool _wasOnline = true;

  OfflineSyncManager(this.syncOfflineReports, this.ref);

  void start() {
    NetworkChecker().onInternetStatusChange.listen((isOnline) async {
      if (isOnline && !_wasOnline) {
        OfflineSnackbar.showBackOnlineWithDebounce();
        try {
          final int syncedCount = await Helpers.retryWithBackoff(
            () => syncOfflineReports.call(),
          );
          if (syncedCount > 0) {
            // Only show notification if reports were actually synced
            await LocalNotificationService().showNotification(
              title: 'Reports Synced',
              body:
                  'Your $syncedCount offline report${syncedCount > 1 ? 's' : ''} have been submitted successfully.',
            );
            // Refresh My Reports provider after sync
            ref.read(myReportsProvider.notifier).refreshReports();
          }
        } catch (e) {
          // show error when sync fails
          OfflineSnackbar.showError('Failed to sync offline reports: $e');
        }
      } else if (!isOnline) {
        OfflineSnackbar.showWithDebounce();
      }
      _wasOnline = isOnline;
    });
  }
}
