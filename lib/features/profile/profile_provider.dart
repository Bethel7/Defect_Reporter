import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_model.dart';
import '../../services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

/// In-memory cache for the last fetched profile (per app session).
ProfileModel? _cachedProfile;

final profileProvider = FutureProvider<ProfileModel>((ref) async {
  final service = ref.read(profileServiceProvider);
  try {
    final profile = await service.fetchProfile();
    _cachedProfile = profile;
    return profile;
  } catch (e, st) {
    // If offline or error, return cached profile if available
    if (_cachedProfile != null) {
      return _cachedProfile!;
    }
    // Rethrow to let Riverpod handle the error state
    throw AsyncError(e, st);
  }
});
