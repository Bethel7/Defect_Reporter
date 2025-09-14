import 'package:hive/hive.dart';
import '../features/report/data/location_model.dart';

class LocationHiveService {
  static const String boxName = 'locationsBox';

  Future<void> saveLocations(List<LocationModel> locations) async {
    final box = await Hive.openBox(boxName);
    await box.put('locations', locations.map((l) => l.toJson()).toList());
  }

  Future<List<LocationModel>> getLocations() async {
    final box = await Hive.openBox(boxName);
    final data = box.get('locations');
    if (data == null) return [];
    return List<LocationModel>.from(
      (data as List).map((json) => LocationModel.fromJson(json)),
    );
  }
}
