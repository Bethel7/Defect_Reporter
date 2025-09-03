import 'package:hive/hive.dart';
part 'report_model.g.dart';

const String statusSubmitted = 'Submitted';
const String statusInProgress = 'In Progress';
const String statusResolved = 'Resolved';

@HiveType(typeId: 0)
class ReportModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String status;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final DateTime timestamp;
  @HiveField(6)
  final double? latitude;
  @HiveField(7)
  final double? longitude;
  @HiveField(8)
  final String? locationName;
  @HiveField(9)
  final int? locationId;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.imageUrl,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.locationName,
    this.locationId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id:
        json['id'] as String? ??
        json['reportID']?.toString() ??
        json['ReportID']?.toString() ??
        '',
    title: json['title'] as String? ?? json['Title'] ?? '',
    description: json['description'] as String? ?? json['Description'] ?? '',
    // Accept both nested and root-level locationName
    locationName:
        (json['location']?['locationName'] as String?) ??
        json['LocationName'] as String? ??
        json['locationName'] as String? ??
        '',
    // Accept both nested and root-level status
    status:
        (json['status']?['statusName'] as String?) ??
        json['Status'] as String? ??
        json['statusName'] as String? ??
        '',
    imageUrl:
        json['imageUrl'] as String? ??
        json['ImageUrl'] ??
        json['imagePath'] ??
        json['ImagePath'] ??
        '',
    timestamp:
        DateTime.tryParse(json['timestamp'] ?? json['Timestamp'] ?? '') ??
        DateTime.now(),
    latitude:
        (json['latitude'] as num?)?.toDouble() ??
        (json['Latitude'] as num?)?.toDouble(),
    longitude:
        (json['longitude'] as num?)?.toDouble() ??
        (json['Longitude'] as num?)?.toDouble(),
    locationId:
        json['locationId'] as int? ??
        json['LocationID'] as int? ??
        (json['locationID'] is String
            ? int.tryParse(json['locationID'])
            : json['locationID'] as int?) ??
        null,
  );

  Map<String, dynamic> toJson() => {
    // 'reportID': id, // Uncomment if backend expects reportID
    'title': title,
    'description': description,
    'location': locationName != null ? {'locationName': locationName} : null,
    'locationId': locationId,
    'status': status.isNotEmpty
        ? {'statusName': status}
        : {'statusName': 'Open'},
    'imagePath': imageUrl, // Use 'imagePath' if backend expects this
    'timestamp': timestamp.toIso8601String(),
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
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? locationName,
    int? locationId,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      locationName: location ?? this.locationName,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationId: locationId ?? this.locationId,
    );
  }
}
