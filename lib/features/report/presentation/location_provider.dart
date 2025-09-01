import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/location_api_service.dart';

final locationApiServiceProvider = Provider<LocationApiService>((ref) {
  return LocationApiService();
});

final activeLocationsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final service = ref.watch(locationApiServiceProvider);
  return await service.getActiveLocations();
});
