enum UserRole { admin, user, unknown }

class UserModel {
  final int userId; // Backend integer userId (optional)
  final String fullName;
  final UserRole role;
  final String employeeId;
  final String email;

  const UserModel({
    this.userId = 0,
    required this.fullName,
    required this.role,
    required this.employeeId,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId:
        json['UserId'] as int? ??
        json['userId'] as int? ??
        int.tryParse(
          json['UserId']?.toString() ?? json['userId']?.toString() ?? '',
        ) ??
        0,
    fullName: json['FullName'] as String? ?? json['fullName'] as String? ?? '',
    role: _roleFromString(json['Role'] as String? ?? json['role'] as String?),
    employeeId:
        json['employeeID'] as String? ?? json['employeeId'] as String? ?? '',
    email: json['email'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'role': role.name,
    'employeeId': employeeId,
    'email': email,
  };

  UserModel copyWith({
    int? userId,
    String? fullName,
    UserRole? role,
    String? employeeId,
    String? email,
  }) => UserModel(
    userId: userId ?? this.userId,
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    employeeId: employeeId ?? this.employeeId,
    email: email ?? this.email,
  );

  static UserRole _roleFromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
      case 'employee':
        return UserRole.user;
      default:
        return UserRole.unknown;
    }
  }
}
