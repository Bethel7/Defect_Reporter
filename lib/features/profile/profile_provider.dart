import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_model.dart';

final profileProvider = StateProvider<ProfileModel>((ref) {
  return ProfileModel(
    name: 'Berhanu Girma',
    employeeId: 'ET12345',
    email: 'BerhanuGirma@ethiopianairlines.com',
  );
});