class ReportModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String status;
  final String imageUrl;
  final String imagePath;
  final DateTime createdAt;
  final String? aiDepartment;
  final String? aiSeverity;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.imageUrl,
    required this.imagePath,
    required this.createdAt,
    this.aiDepartment,
    this.aiSeverity,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    location: json['location'] as String,
    status: json['status'] as String,
    imageUrl: json['imageUrl'] as String,
    imagePath: json['imagePath']as String,
    createdAt: json['createdAt'] == null
        ? DateTime.now()
        : DateTime.parse(json['createdAt']as String),
    aiDepartment: json['aiDepartment'] as String?,
    aiSeverity: json['aiSeverity'] as String?,
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
  };
}
