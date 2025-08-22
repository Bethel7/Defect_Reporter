import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_model.dart';
import '../../services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(baseUrl: 'http://svdcbas02:8212');
});

final profileProvider = FutureProvider<ProfileModel>((ref) async {
  final service = ref.read(profileServiceProvider);
  return await service.fetchProfile();
});
