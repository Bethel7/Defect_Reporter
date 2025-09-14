import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? type; // status update or general
  final String? reportId;
  final String? status;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type,
    this.reportId,
    this.status,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    String? reportId,
    String? status,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      reportId: reportId ?? this.reportId,
      status: status ?? this.status,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Map backend fields to model fields
    return NotificationModel(
      id: (json['notificationID'] ).toString(),
      title:
          json['relatedReport'] != null &&
              json['relatedReport']['title'] != null
          ? json['relatedReport']['title']
          : (json['type'] ?? json['message'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      timestamp: DateTime.parse(
        json['createdAt'] ??
            json['timestamp'] ??
            DateTime.now().toIso8601String(),
      ),
      isRead: json['isRead'] as bool? ?? false,
      type: (json['type'] ?? '').toString(),
      reportId: (json['reportID'] ?? json['reportId'] ?? '').toString(),
      status:
          json['relatedReport'] != null &&
              json['relatedReport']['status'] != null
          ? json['relatedReport']['status'].toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type,
      'reportId': reportId,
      'status': status,
    };
  }

  bool get isStatusUpdate => type == 'status';

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    timestamp,
    isRead,
    type,
    reportId,
    status,
  ];
}
