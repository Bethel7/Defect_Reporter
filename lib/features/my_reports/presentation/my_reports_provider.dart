import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../report/data/report_model.dart';
import '../../../services/report_service.dart';

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
  final ReportService _reportService = ReportService();

  MyReportsNotifier() : super(MyReportsState(reports: []));

  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final reports = await _reportService.getMyReports();
      state = state.copyWith(reports: reports, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<ReportModel?> fetchReportById(String id) async {
    try {
      final report = await _reportService.getMyReportById(id);
      return report;
    } catch (e) {
      return null;
    }
  }

  void addReport(ReportModel report) {
    state = state.copyWith(reports: [...state.reports, report]);
  }

  Future<void> refreshReports() async {
    await loadReports();
  }
}

final myReportsProvider =
    StateNotifierProvider<MyReportsNotifier, MyReportsState>((ref) {
      final notifier = MyReportsNotifier();
      notifier.loadReports();
      return notifier;
    });
