import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../report/data/report_model.dart';

// State class using ReportModel
class MyReportsState {
  final List<ReportModel> reports;
  final bool isLoading;
  final String? error;

  MyReportsState({
    required this.reports,
    this.isLoading = false,
    this.error,
  });

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

// Notifier using ReportModel
class MyReportsNotifier extends StateNotifier<MyReportsState> {
  MyReportsNotifier() : super(MyReportsState(reports: []));

  void addReport(ReportModel report) {
    state = state.copyWith(reports: [...state.reports, report]);
  }

  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Simulate loading
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        reports: [
          ReportModel(
            id: '1',
            title: 'Broken seat',
            description: 'Seat 12A is broken.',
            location: 'Main Hub',
            status: ReportModel.statusResolved,
            imageUrl: null,
            aiDepartment: null,
            aiSeverity: null,
            timestamp: DateTime(2023, 10, 10, 14, 30),
          ),
          ReportModel(
            id: '2',
            title: 'Faulty air conditioner',
            description: 'AC not working in waiting area.',
            location: 'MRO Facility',
            status: ReportModel.statusResolved,
            imageUrl: null,
            aiDepartment: null,
            aiSeverity: null,
            timestamp: DateTime(2024, 12, 23, 10, 0),
          ),
          ReportModel(
            id: '3',
            title: 'Delayed Departure',
            description: 'Flight ET123 delayed.',
            location: 'Cargo & Logistics Center',
            status: ReportModel.statusInProgress,
            imageUrl: null,
            aiDepartment: null,
            aiSeverity: null,
            timestamp: DateTime(2025, 1, 17, 18, 45),
          ),
        ],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final myReportsProvider =
    StateNotifierProvider<MyReportsNotifier, MyReportsState>((ref) {
  final notifier = MyReportsNotifier();
  notifier.loadReports();
  return notifier;
});