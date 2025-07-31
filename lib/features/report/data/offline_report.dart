import 'package:hive/hive.dart';

part 'offline_report.g.dart';

@HiveType(typeId: 0)
class OfflineReport extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String imagePath;
  @HiveField(4)
  DateTime createdAt;
  @HiveField(5)
  String location;
  @HiveField(6)
  String status;

  OfflineReport({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.createdAt,
    required this.location,
    this.status = 'pending',
  });
}
