class UserModel {
  final String fullName;
  final String role;

  UserModel({required this.fullName, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    fullName: json['FullName'] as String? ?? '',
    role: json['Role'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'fullName': fullName, 'role': role};
}
