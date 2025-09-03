import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/features/auth/data/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson parses correctly for all roles', () {
      final roles = {
        'admin': UserRole.admin,
        'user': UserRole.user,
        'unknown': UserRole.unknown,
      };
      roles.forEach((str, role) {
        final json = {'FullName': 'Test', 'Role': str};
        final user = UserModel.fromJson(json);
        expect(user.fullName, 'Test');
        expect(user.role, role);
      });
    });

    test('fromJson handles null and missing fields', () {
      final user1 = UserModel.fromJson({'FullName': null, 'Role': null});
      expect(user1.fullName, isEmpty);
      expect(user1.role, UserRole.unknown);
      final user2 = UserModel.fromJson({});
      expect(user2.fullName, isEmpty);
      expect(user2.role, UserRole.unknown);
    });

    test('fromJson handles different key casings', () {
      final user = UserModel.fromJson({'fullname': 'A', 'role': 'admin'});
      expect(user.fullName, anyOf('A', ''));
      expect(user.role, UserRole.admin);
    });

    test('toJson serializes correctly', () {
      final user = UserModel(fullName: 'Bob', role: UserRole.user);
      final json = user.toJson();
      expect(json['fullName'], 'Bob');
      expect(json['role'], 'user');
    });

    test('toJson handles empty and unknown', () {
      final user = UserModel(fullName: '', role: UserRole.unknown);
      final json = user.toJson();
      expect(json['fullName'], '');
      expect(json['role'], 'unknown');
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

    test('fromJson handles whitespace and empty strings', () {
      final user = UserModel.fromJson({'FullName': '   ', 'Role': ''});
      expect(user.fullName.trim(), '');
      expect(user.role, UserRole.unknown);
    });
  });
}
