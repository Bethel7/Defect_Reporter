import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../report/data/report_model.dart';
import '../../report/domain/report_repository.dart';

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

class MyReportsNotifier extends StateNotifier<MyReportsState> {
  final ReportRepository _repository;
  final int userId;

  MyReportsNotifier(this._repository, this.userId)
    : super(MyReportsState(reports: [])) {
    assert(userId != null, 'userId must not be null');
    print(
      '[MyReportsNotifier] Constructed with userId: $userId (type: ${userId.runtimeType})',
    );
  }

  Future<void> loadReports() async {
    print(
      '[MyReportsNotifier] loadReports called with userId: $userId (type: ${userId.runtimeType})',
    );
    state = state.copyWith(isLoading: true, error: null);
    try {
      final reports = await _repository.getMyReports(userId);
      state = state.copyWith(reports: reports, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load reports. Please try again later.',
      );
    }
  }

  // Removed fetchReportById: not needed, always pass full ReportModel object to detail pages.

  void addReport(ReportModel report) {
    state = state.copyWith(reports: [...state.reports, report]);
  }

  Future<void> refreshReports() async {
    await loadReports();
  }
}

// Usage: pass repository and userId when creating the provider
final myReportsProvider =
    StateNotifierProvider.family<
      MyReportsNotifier,
      MyReportsState,
      Map<String, dynamic>
    >((ref, args) {
      final repository = args['repository'] as ReportRepository;
      final userId = args['userId'] as int;
      final notifier = MyReportsNotifier(repository, userId);
      notifier.loadReports();
      return notifier;
    });
