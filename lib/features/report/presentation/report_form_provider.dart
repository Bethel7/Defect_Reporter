import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../services/location_service.dart';
import '../../../../services/location_api_service.dart';
import 'report_form_state.dart';
import '../../report/data/report_remote_data_source.dart';
import '../../report/data/report_model.dart';
import '../../../core/utils/validators.dart';

final createLocation = Provider<LocationApiService>((ref) => LocationApiService());

final reportFormProvider =
    StateNotifierProvider<ReportFormNotifier, ReportFormState>(
      (ref) =>
          ReportFormNotifier(locationApiService: ref.read(createLocation)),
    );

class ReportFormNotifier extends StateNotifier<ReportFormState> {
  String? get locationError =>
      Validators.validateLocationId(state.locationId?.toString());
  String? get imageError => Validators.validateImagePath(state.imagePath);
  final ReportRemoteDataSource _reportRemoteDataSource;
  final LocationService _locationService;
  final LocationApiService _locationApiService;

  ReportFormNotifier({
    ReportRemoteDataSource? reportRemoteDataSource,
    LocationService? locationService,
    LocationApiService? locationApiService,
  }) : _reportRemoteDataSource =
           reportRemoteDataSource ?? ReportRemoteDataSourceImpl(),
       _locationService = locationService ?? LocationService(),
       _locationApiService = locationApiService ?? LocationApiService(),
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
      // Validate image only (location handled below)
      final imageError = Validators.validateImagePath(state.imagePath);
      if (imageError != null) {
        state = state.copyWith(error: imageError);
        return null;
      }

      int? locationId = state.locationId;
      String? locationName = state.locationName;

      // If no locationId but a locationName is provided, create the location using LocationApiService
      if ((locationId == null || locationId == 0) &&
          locationName != null &&
          locationName.trim().isNotEmpty) {
        try {
          locationId = await _locationApiService.createLocation(
            locationName.trim(),
          );
        } catch (e) {
          state = state.copyWith(
            error: 'Failed to create location: ${e.toString()}',
          );
          return null;
        }
      }

      // Validate locationId after possible creation
      final locationError = Validators.validateLocationId(
        locationId?.toString(),
      );
      if (locationError != null) {
        state = state.copyWith(error: locationError);
        return null;
      }

      // Get current location (lat/lng)
      final position = await _locationService.getCurrentLocation(context);
      final latitude = position?.latitude;
      final longitude = position?.longitude;

      // Prepare ReportModel for submission
      final report = ReportModel(
        id: '',
        title: state.title,
        description: state.description,
        status: 'Submitted',
        imageUrl: state.imagePath,
        timestamp: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        locationId: locationId,
      );
      // Use the unified endpoint for single report
      final ids = await _reportRemoteDataSource.submitReports([report]);
      final reportId = ids.isNotEmpty ? ids.first : '';
      final timestamp = DateTime.now().toIso8601String();
      return {'reportId': reportId, 'timestamp': timestamp};
    } catch (e) {
      // Only set error for real exceptions (not validation)
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
