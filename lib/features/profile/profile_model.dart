class ProfileModel {
  final String fullName;
  final String employeeId;
  final String email;
  final String role;
  final bool isActive;
  final String createdAt;

  ProfileModel({
    required this.fullName,
    required this.employeeId,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

factory ProfileModel.fromJson(Map<String, dynamic> json) {
  final data = json.containsKey('data')
      ? json['data']
      : (json.containsKey('Data') ? json['Data'] : json);
  return ProfileModel(
    fullName: data['fullName'] as String? ?? '',
    employeeId: data['employeeID'] as String? ?? '',
    email: data['email'] as String? ?? '',
    role: data['role'] as String? ?? '',
    isActive: data['isActive'] as bool? ?? false,
    createdAt: data['createdAt']?.toString() ?? '',
  );
}
}
