/// Model representing a user profile.
class ProfileModel {
  final String fullName;
  final String employeeId;
  final String email;
  final String role;
  final bool isActive;
  final DateTime? createdAt;

  ProfileModel({
    required this.fullName,
    required this.employeeId,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  /// Creates a ProfileModel from JSON, handling nested 'data' or 'Data' keys.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json['Data'] ?? json;
    return ProfileModel(
      fullName: data['fullName'] as String? ?? '',
      employeeId: data['employeeID'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? false,
      createdAt: _parseDateTime(data['createdAt']),
    );
  }

  /// Converts the ProfileModel to JSON.
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'employeeID': employeeId,
      'email': email,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Helper to parse DateTime from various formats.
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
