enum UserRole { sysAdmin, deptAdmin, employee, unknown }

class UserModel {
  final int id;
  final String fullName;
  final UserRole role;
  final String employeeId;
  final String email;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.employeeId,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse ID with better error handling
    final id = _parseInt(json['user']['id']);

    if (id <= 0) {
      throw FormatException('User ID is required and must be positive');
    }

    return UserModel(
      id: id,
      fullName: _parseString(json['user']['fullName'], 'Full Name'),
      role: _roleFromString(json['user']['role']),
      employeeId: _parseString(json['user']['employeeID'], 'Employee ID'),
      email: _parseString(json['user']['email'], 'Email'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'role': _roleToString(role),
    'employeeId': employeeId,
    'email': email,
  };

  UserModel copyWith({
    int? id,
    String? fullName,
    UserRole? role,
    String? employeeId,
    String? email,
  }) => UserModel(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    employeeId: employeeId ?? this.employeeId,
    email: email ?? this.email,
  );

  // Helper methods
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      // Handle cases where string might have extra spaces or characters
      final cleaned = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleaned) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }

  static String _parseString(dynamic value, String fieldName) {
    final result = value != null ? value.toString().trim() : '';
    if (result.isEmpty) {
      throw FormatException('$fieldName is required');
    }
    return result;
  }

  static UserRole _roleFromString(dynamic value) {
    final stringValue = value?.toString().trim() ?? '';

    switch (stringValue) {
      case 'sysAdmin':
        return UserRole.sysAdmin;
      case 'deptAdmin':
        return UserRole.deptAdmin;
      case 'employee':
        return UserRole.employee;
      default:
        return UserRole.unknown;
    }
  }

  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.sysAdmin:
        return 'sysAdmin';
      case UserRole.deptAdmin:
        return 'deptAdmin';
      case UserRole.employee:
        return 'employee';
      case UserRole.unknown:
        return 'unknown';
    }
  }

  // Convenience getters
  bool get isSysAdmin => role == UserRole.sysAdmin;
  bool get isDeptAdmin => role == UserRole.deptAdmin;
  bool get isEmployee => role == UserRole.employee;
  bool get isAdmin => isSysAdmin || isDeptAdmin; // Both admin types
  bool get isUnknown => role == UserRole.unknown;

  @override
  String toString() =>
      'UserModel(id: $id, fullName: "$fullName", role: $role, '
      'employeeId: "$employeeId", email: "$email")';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          role == other.role &&
          employeeId == other.employeeId &&
          email == other.email;

  @override
  int get hashCode => Object.hash(id, fullName, role, employeeId, email);
}
