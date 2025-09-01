import 'package:dio/dio.dart';
import '../api_client.dart';

class LocationApiService {
  final Dio _dio = ApiClient().dio;

  /// Get all active locations 
  Future<List<Map<String, dynamic>>> getActiveLocations() async {
    final response = await _dio.get('/api/location/GetLocationsActive');
    if (response.statusCode == 200) {
      final data = response.data['Data'];
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        return <Map<String, dynamic>>[];
      }
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to fetch locations');
    }
  }

  /// Create a new location
  Future<int> createLocation(String locationName) async {
    final response = await _dio.post(
      '/api/location/CreateLocation',
      data: {'LocationName': locationName},
    );
    if (response.statusCode == 201) {
      return response.data['LocationId'] as int;
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to create location');
    }
  }
}
