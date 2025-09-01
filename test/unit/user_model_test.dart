import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/features/auth/data/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson parses correctly', () {
      final json = {'FullName': 'Alice', 'Role': 'admin'};
      final user = UserModel.fromJson(json);
      expect(user.fullName, 'Alice');
      expect(user.role, UserRole.admin);
    });

    test('toJson serializes correctly', () {
      final user = UserModel(fullName: 'Bob', role: UserRole.user);
      final json = user.toJson();
      expect(json['fullName'], 'Bob');
      expect(json['role'], 'user');
    });

    test('copyWith creates a copy with new values', () {
      final user = UserModel(fullName: 'Carol', role: UserRole.user);
      final updated = user.copyWith(fullName: 'Dave', role: UserRole.admin);
      expect(updated.fullName, 'Dave');
      expect(updated.role, UserRole.admin);
    });

    test('role parsing returns unknown for invalid role', () {
      final json = {'FullName': 'Eve', 'Role': 'notarole'};
      final user = UserModel.fromJson(json);
      expect(user.role, UserRole.unknown);
    });
  });
}
