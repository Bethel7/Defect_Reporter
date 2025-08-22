import 'package:dio/dio.dart';
import '../features/profile/profile_model.dart';

class ProfileService {
  final Dio _dio;
  ProfileService({required String baseUrl})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<ProfileModel> fetchProfile() async {
    final response = await _dio.get('/api/auth/my-profile');
    return ProfileModel.fromJson(response.data);
  }
}
