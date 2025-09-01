import 'package:dio/dio.dart';
import '../features/profile/profile_model.dart';
import '../api_client.dart';

class ProfileService {
  final Dio _dio;
  ProfileService() : _dio = ApiClient().dio;

  Future<ProfileModel> fetchProfile() async {
    // Print cookies before fetching profile
    final apiClient = ApiClient();
    final cookies = await apiClient.cookieJar.loadForRequest(
      Uri.parse(apiClient.dio.options.baseUrl),
    );
    

    final response = await _dio.get('/api/auth/my-profile');
    return ProfileModel.fromJson(response.data);
  }
}
