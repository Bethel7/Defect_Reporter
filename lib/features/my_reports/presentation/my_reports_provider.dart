import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dummy report model for demonstration
class MyReport {
  final String title;
  final String date;
  final String status;

  MyReport({required this.title, required this.date, required this.status});
}

class MyReportsState {
  final List<MyReport> reports;
  final bool isLoading;
  final String? error;

  MyReportsState({
    required this.reports,
    this.isLoading = false,
    this.error,
  });

  MyReportsState copyWith({
    List<MyReport>? reports,
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
  MyReportsNotifier() : super(MyReportsState(reports: []));

  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Simulate loading
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        reports: [
          MyReport(title: 'Broken seat', date: '10th oct 2023', status: 'Resolved'),
          MyReport(title: 'Faulty air conditioner', date: '23th dec 2024', status: 'Resolved'),
          MyReport(title: 'Delayed  Departure', date: '17th jan 2025', status: 'In progress'),
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