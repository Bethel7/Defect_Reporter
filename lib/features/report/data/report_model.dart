import 'package:hive/hive.dart';
part 'report_model.g.dart';

const String statusSubmitted = 'Submitted';
const String statusInProgress = 'In Progress';
const String statusResolved = 'Resolved';

@HiveType(typeId: 0)
class ReportModel {
  @HiveField(0)
  final String? localId;
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

  // Nullable reportId for backend reference (not used in Hive)
  final String? reportId;

  ReportModel({
    this.localId,
    required this.title,
    required this.description,
    required this.status,
    required this.imageUrl,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.locationName,
    this.locationId,
    this.reportId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    String? localId;
    if (json.containsKey('localId')) {
      final val = json['localId'];
      if (val is String && val.isNotEmpty) {
        localId = val;
      } else {
        localId = null;
      }
    }
    // Get image path from possible keys
    String imagePath =
        json['ImagePath'] ??
        json['imageUrl'] ??
        json['ImageUrl'] ??
        json['imagePath'] ??
        '';
    // Prepend baseUrl if imagePath is a relative path
    const String baseUrl = 'http://svdcbas02:8212';
    String fullImageUrl = imagePath;
    if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      // Remove any leading slash to avoid double slash
      if (imagePath.startsWith('/')) {
        fullImageUrl = baseUrl + imagePath;
      } else {
        fullImageUrl = baseUrl + '/' + imagePath;
      }
    }
    return ReportModel(
      localId: localId,
      title: json['title'] ?? json['Title'] ?? '',
      description: json['description'] ?? json['Description'] ?? '',
      locationName:
          json['location']?['locationName'] ??
          json['LocationName'] ??
          json['locationName'],
      status:
          (json['status']?['statusName']) ??
          json['Status'] ??
          json['statusName'] ??
          '',
      imageUrl: fullImageUrl,
      timestamp: DateTime.now(),
      latitude: (json['Latitude'] as num?)?.toDouble(),
      longitude: (json['Longitude'] as num?)?.toDouble(),
      locationId: json['locationId'] as int?,
      reportId: json['ReportID']?.toString() ?? json['reportID']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (localId != null && localId!.isNotEmpty) 'localId': localId,
      'title': title,
      'description': description,
      'locationName': locationName,
      'locationId': locationId,
      'status': status,
      'imagePath': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      if (reportId != null) 'reportId': reportId,
    };
  }

  ReportModel copyWith({
    String? localId,
    String? title,
    String? description,
    String? status,
    String? imageUrl,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? locationName,
    int? locationId,
    String? reportId,
  }) {
    return ReportModel(
      localId: localId ?? this.localId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      locationId: locationId ?? this.locationId,
      reportId: reportId ?? this.reportId,
    );
  }
}
