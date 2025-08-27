class ReportModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String status;
  final String imageUrl;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String? locationName;

  static const String statusSubmitted = 'Submitted';
  static const String statusInProgress = 'In Progress';
  static const String statusResolved = 'Resolved';

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.imageUrl,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.locationName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: json['id'] as String? ?? json['reportID']?.toString() ?? '',
    title: json['title'] as String? ?? json['title'] ?? '',
    description: json['description'] as String? ?? json['description'] ?? '',
    location: json['location'] as String? ?? json['location'] ?? '',
    status: json['status'] as String? ?? json['status'] ?? '',
    imageUrl: json['imageUrl'] as String? ?? json['imagePath'] ?? '',
    timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    locationName: json['locationName'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'status': status,
    'imageUrl': imageUrl,
    'timestamp': timestamp.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'locationName': locationName,
  };

  ReportModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? status,
    String? imageUrl,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? locationName,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
    );
  }
}
