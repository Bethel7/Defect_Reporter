import 'package:dio/dio.dart';
import '../api_client.dart';

class LocationApiService {
  final Dio _dio;

  LocationApiService({Dio? dio}) : _dio = dio ?? ApiClient().dio;

  /// Get all active locations
  Future<List<Map<String, dynamic>>> getActiveLocations() async {
    final response = await _dio.get('/api/location/GetLocationsActive');
    // Print the full response for debugging
    // ignore: avoid_print
    print(
      'Raw location response: \nStatus: ${response.statusCode}\nData: ${response.data}',
    );
    if (response.statusCode == 200) {
      // Try both 'Data' and 'data' fields for robustness
      final data = response.data['Data'] ?? response.data['data'];
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        // ignore: avoid_print
        print(
          'LocationApiService: Data field is not a List. Actual: ${data.runtimeType}',
        );
        return <Map<String, dynamic>>[];
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Session/authentication error
      print('LocationApiService: Session/authentication error.');
      throw Exception('Authentication required. Please log in again.');
    } else {
      // ignore: avoid_print
      print('LocationApiService: Error response: ${response.data}');
      throw Exception(response.data['Message'] ?? 'Failed to fetch locations');
    }
  }

  /// Create a new location
  Future<int> createLocation(String locationName) async {
    if (locationName.trim().isEmpty) {
      throw Exception('Location name cannot be empty.');
    }
    try {
      final response = await _dio.post(
        '/api/location/CreateLocation',
        data: {'LocationName': locationName.trim()},
      );
      // Print for debugging
      print(
        'CreateLocation response: status=${response.statusCode}, data=${response.data}',
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final id =
            response.data['LocationID'] ??
            response.data['locationId'] ??
            response.data['id'];
        if (id == null) {
          throw Exception('Location created but no ID returned.');
        }
        return int.tryParse(id.toString()) ??
            (throw Exception('Invalid location ID format.'));
      } else {
        final msg =
            response.data['Message'] ??
            response.data['message'] ??
            'Failed to create location';
        throw Exception(msg);
      }
    } catch (e) {
      print('LocationApiService.createLocation error: $e');
      throw Exception('Failed to create location: $e');
    }
  }
}
