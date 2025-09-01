import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class ReportUtils {
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return AppColors.primary;
      case 'in progress':
        return const Color(0xFFF59E42);
      case 'submitted':
        return const Color(0xFF64748B);
      default:
        return Colors.grey;
    }
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
