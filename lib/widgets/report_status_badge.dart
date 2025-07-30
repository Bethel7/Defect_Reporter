import 'package:flutter/material.dart';

class ReportStatusBadge extends StatelessWidget {
  final String status;

  const ReportStatusBadge({super.key, required this.status});

  Color _getColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getColor(status)),
      ),
      child: Text(
        status,
        style: TextStyle(color: _getColor(status), fontWeight: FontWeight.bold),
      ),
    );
  }
}
