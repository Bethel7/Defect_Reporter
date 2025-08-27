import 'package:dio/dio.dart';
import '../api_client.dart';

class LocationApiService {
  final Dio _dio = ApiClient().dio;

  /// Get all active locations
  Future<List<Map<String, dynamic>>> getActiveLocations() async {
    final response = await _dio.get('/api/location/GetLocationsActive');
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data['Data'] ?? []);
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to fetch locations');
    }
  }

  /// Get a specific location by ID
  Future<Map<String, dynamic>> getLocationById(int id) async {
    final response = await _dio.get('/api/location/GetLocation/$id');
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data['Data'] ?? {});
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to fetch location');
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
