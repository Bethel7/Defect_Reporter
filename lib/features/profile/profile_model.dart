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
    // Handles both direct and wrapped (Data) responses
    final data = json.containsKey('Data') ? json['Data'] : json;
    return ProfileModel(
      fullName: data['FullName'] as String? ?? '',
      employeeId: data['EmployeeID'] as String? ?? '',
      email: data['Email'] as String? ?? '',
      role: data['Role'] as String? ?? '',
      isActive: data['IsActive'] as bool? ?? false,
      createdAt: data['CreatedAt']?.toString() ?? '',
    );
  }
}
