class UserModel {
  final String employeeId;
  final String fullName;
  final String? token;

  UserModel({
    required this.employeeId,
    required this.fullName,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        employeeId: json['employeeId'] as String,
        fullName: json['fullName'] as String,
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'fullName': fullName,
        'token': token,
      };
}