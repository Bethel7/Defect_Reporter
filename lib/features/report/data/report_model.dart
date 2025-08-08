class ReportModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String status;
  final String? imageUrl;
  final String? aiDepartment;
  final String? aiSeverity;
  final DateTime? timestamp;
  final double? latitude;
  final double? longitude;

  static const String statusSubmitted = 'Submitted';
  static const String statusInProgress = 'In Progress';
  static const String statusResolved = 'Resolved';

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    this.imageUrl,
    this.aiDepartment,
    this.aiSeverity,
    this.timestamp,
    this.latitude,
    this.longitude,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    location: json['location'] as String,
    status: json['status'] as String,
    imageUrl: json['imageUrl'] as String?,
    aiDepartment: json['aiDepartment'] as String?,
    aiSeverity: json['aiSeverity'] as String?,
    timestamp: json['timestamp'] != null
        ? DateTime.tryParse(json['timestamp'])
        : null,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'status': status,
    'imageUrl': imageUrl,
    'aiDepartment': aiDepartment,
    'aiSeverity': aiSeverity,
    'timestamp': timestamp?.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
  };

  ReportModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? status,
    String? imageUrl,
    String? aiDepartment,
    String? aiSeverity,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      aiDepartment: aiDepartment ?? this.aiDepartment,
      aiSeverity: aiSeverity ?? this.aiSeverity,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
