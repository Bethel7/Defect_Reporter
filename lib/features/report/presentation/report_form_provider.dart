import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'report_form_state.dart';

final reportFormProvider =
    StateNotifierProvider<ReportFormNotifier, ReportFormState>(
        (ref) => ReportFormNotifier());

class ReportFormNotifier extends StateNotifier<ReportFormState> {
  ReportFormNotifier() : super(ReportFormState.initial());

  void setTitle(String title) => state = state.copyWith(title: title);
  void setDescription(String desc) => state = state.copyWith(description: desc);
  void setLocation(String loc) => state = state.copyWith(location: loc);
  void setImagePath(String path) => state = state.copyWith(imagePath: path);
void reset() {
  state = ReportFormState.initial();
}

  Future<Map<String, String>?> submit() async {
  state = state.copyWith(isSubmitting: true, error: null);
  try {
    // Simulate submission and generate ID/timestamp
    await Future.delayed(const Duration(seconds: 1));
    final reportId = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = DateTime.now().toString().substring(0, 16);
    // On success, return the info
    return {'reportId': reportId, 'timestamp': timestamp};
  } catch (e) {
    state = state.copyWith(error: e.toString());
    return null;
  } finally {
    state = state.copyWith(isSubmitting: false);
  }
}
}