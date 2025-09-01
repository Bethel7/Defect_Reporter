import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';

enum ReportStatus { resolved, inProgress, submitted, unknown }

ReportStatus parseReportStatus(String status) {
  switch (status.toLowerCase()) {
    case 'resolved':
      return ReportStatus.resolved;
    case 'in progress':
      return ReportStatus.inProgress;
    case 'submitted':
      return ReportStatus.submitted;
    default:
      return ReportStatus.unknown;
  }
}

Color statusColor(ReportStatus status) {
  switch (status) {
    case ReportStatus.resolved:
      return AppColors.primary;
    case ReportStatus.inProgress:
      return const Color(0xFFF59E42);
    case ReportStatus.submitted:
      return const Color(0xFF64748B);
    default:
      return Colors.grey;
  }
}

Icon statusIcon(ReportStatus status) {
  switch (status) {
    case ReportStatus.resolved:
      return Icon(FontAwesomeIcons.circleCheck, color: AppColors.primary, size: 18);
    case ReportStatus.inProgress:
      return Icon(FontAwesomeIcons.triangleExclamation, color: Color(0xFFF59E42), size: 18);
    case ReportStatus.submitted:
      return Icon(FontAwesomeIcons.paperPlane, color: Color(0xFF64748B), size: 18);
    default:
      return Icon(FontAwesomeIcons.circleInfo, color: Colors.grey, size: 18);
  }
}

class ReportStatusBadge extends StatelessWidget {
  final ReportStatus status;
  final String label;
  const ReportStatusBadge({required this.status, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor(status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
