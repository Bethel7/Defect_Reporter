import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/location_api_service.dart';
import '../../report/data/location_model.dart';

final locationApiServiceProvider = Provider<LocationApiService>((ref) {
  return LocationApiService();
});

final activeLocationsProvider = FutureProvider<List<LocationModel>>((
  ref,
) async {
  final service = ref.watch(locationApiServiceProvider);
  try {
    final rawLocations = await service.getActiveLocations();
    // Debug log
    // ignore: avoid_print
    print('Locations fetched: $rawLocations');
    return rawLocations.map((json) => LocationModel.fromJson(json)).toList();
  } catch (e) {
    // ignore: avoid_print
    print('Error fetching locations: $e');
    return [];
  }
});
