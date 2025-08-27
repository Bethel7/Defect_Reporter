import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'report_form_state.dart';
import '../../../../services/report_service.dart';
import 'package:dio/dio.dart';
import '../../../../services/location_service.dart';
import 'package:flutter/material.dart';

final reportFormProvider =
    StateNotifierProvider<ReportFormNotifier, ReportFormState>(
      (ref) => ReportFormNotifier(),
    );

class ReportFormNotifier extends StateNotifier<ReportFormState> {
  final ReportService _reportService;

  ReportFormNotifier()
    : _reportService = ReportService(),
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
      // Prepare FormData for image upload and fields
      final formData = FormData.fromMap({
        'Title': state.title,
        'Description': state.description,
        'LocationID': state.locationId,
        'Latitude': latitude,
        'Longitude': longitude,
        'Image': await MultipartFile.fromFile(
          state.imagePath,
          filename: state.imagePath.split('/').last,
        ),
      });
      final reportId = await _reportService.submitReport(formData);
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
