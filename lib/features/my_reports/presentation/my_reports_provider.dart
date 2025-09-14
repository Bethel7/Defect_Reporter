import 'package:defect_reporter/features/auth/presentation/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../report/data/report_model.dart';
import '../../report/domain/report_repository.dart';
import '../../../features/report/data/report_repository_provider.dart';

/// State for user's reports
class MyReportsState {
  final List<ReportModel> reports;
  final bool isLoading;
  final String? error;

  MyReportsState({required this.reports, this.isLoading = false, this.error});

  MyReportsState copyWith({
    List<ReportModel>? reports,
    bool? isLoading,
    String? error,
  }) {
    return MyReportsState(
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier to manage reports
class MyReportsNotifier extends StateNotifier<MyReportsState> {
  final ReportRepository _repository;
  final int id;

  MyReportsNotifier(this._repository, this.id)
    : super(MyReportsState(reports: [])) {
    loadReports(); // Automatically load reports when notifier is created
  }

  Future<void> loadReports() async {
    if (id == 0) {
      state = state.copyWith(
        reports: [],
        isLoading: false,
        error: 'Invalid user ID',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final reports = await _repository.getMyReports(id);
      state = state.copyWith(reports: reports, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load reports. Please try again later.',
      );
    }
  }

  void addReport(ReportModel report) {
    state = state.copyWith(reports: [...state.reports, report]);
  }

  Future<void> refreshReports() async {
    await loadReports();
  }
}

/// Provider to read userId from secure storage
final currentUserIdProvider = Provider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id ?? 0;
});

   final myReportsAsyncProvider = FutureProvider<List<ReportModel>>((ref) async {
  final repository = ref.read(reportRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == 0) {
    debugPrint('[myReportsAsyncProvider] Invalid userId, returning empty list');
    return [];
  }

  try {
    final reports = await repository.getMyReports(userId);
    debugPrint(
      '[myReportsAsyncProvider] Successfully fetched ${reports.length} reports for userId $userId',
    );
    return reports;
  } catch (e, st) {
    debugPrint('[myReportsAsyncProvider] Error fetching reports: $e');
    debugPrintStack(stackTrace: st);
    return [];
  }
});
