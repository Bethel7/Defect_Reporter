import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/location_api_service.dart';
import '../../report/data/location_model.dart';
import '../../../services/location_hive_service.dart';

final locationApiServiceProvider = Provider<LocationApiService>((ref) {
  return LocationApiService();
});

final activeLocationsProvider = FutureProvider<List<LocationModel>>((
  ref,
) async {
  final service = ref.watch(locationApiServiceProvider);
  final hiveService = LocationHiveService();
  try {
    final rawLocations = await service.getActiveLocations();
    final locations = rawLocations
        .map((json) => LocationModel.fromJson(json))
        .toList();
    // Save to Hive for offline use
    await hiveService.saveLocations(locations);
    return locations;
  } catch (e) {
    // If offline or error, fallback to Hive
    final cachedLocations = await hiveService.getLocations();
    // ignore: avoid_print
    print(
      'Error fetching locations: $e, using cached: ${cachedLocations.length}',
    );
    return cachedLocations;
  }
});
