import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../services/location_service.dart';
import 'report_form_state.dart';
import '../../report/data/report_remote_data_source.dart';
import '../../report/data/report_model.dart';

final reportFormProvider =
    StateNotifierProvider<ReportFormNotifier, ReportFormState>(
      (ref) => ReportFormNotifier(),
    );

class ReportFormNotifier extends StateNotifier<ReportFormState> {
  final ReportRemoteDataSource _reportRemoteDataSource;

  ReportFormNotifier()
    : _reportRemoteDataSource = ReportRemoteDataSourceImpl(),
      super(ReportFormState.initial());

  void setTitle(String title) => state = state.copyWith(title: title);
  void setDescription(String desc) => state = state.copyWith(description: desc);
  void setLocation(int? id, String? name) =>
      state = state.copyWith(locationId: id, locationName: name);
  void setImagePath(String path) => state = state.copyWith(imagePath: path);

  void reset() {
    state = ReportFormState.initial();
  }

  Future<Map<String, String>?> submit(BuildContext context) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      // Get current location
      final position = await LocationService().getCurrentLocation(context);
      final latitude = position?.latitude;
      final longitude = position?.longitude;
      // Prepare ReportModel for submission
      final report = ReportModel(
        id: '', // ID will be set by backend
        title: state.title,
        description: state.description,
        location: '', // Set if needed
        status: '', // Set if needed
        imageUrl: state.imagePath,
        timestamp: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        locationName: state.locationName,
      );
      // Use the unified endpoint for single report
      final ids = await _reportRemoteDataSource.submitReports([report]);
      final reportId = ids.isNotEmpty ? ids.first : '';
      final timestamp = DateTime.now().toIso8601String();
      return {'reportId': reportId, 'timestamp': timestamp};
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
