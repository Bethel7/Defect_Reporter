enum UserRole { admin, user, unknown }

class UserModel {
  final String fullName;
  final UserRole role;

  const UserModel({required this.fullName, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    fullName: json['FullName'] as String? ?? '',
    role: _roleFromString(json['Role'] as String?),
  );

  Map<String, dynamic> toJson() => {'fullName': fullName, 'role': role.name};

  UserModel copyWith({String? fullName, UserRole? role}) =>
      UserModel(fullName: fullName ?? this.fullName, role: role ?? this.role);

  static UserRole _roleFromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.unknown;
    }
  }
}
