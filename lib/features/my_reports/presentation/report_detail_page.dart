import 'dart:io';
import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../report/data/report_model.dart';

class ReportDetailPage extends StatelessWidget {
  final ReportModel report;

  const ReportDetailPage({
    super.key,
    required this.report,
  });

  Color statusColor(String status) {
    switch (status) {
      case ReportModel.statusResolved:
        return Colors.green;
      case ReportModel.statusInProgress:
        return Colors.orange;
      case ReportModel.statusSubmitted:
      default:
        return Colors.blueGrey;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        title: Semantics(
          label: 'Report Detail Page',
          header: true,
          child: Text(
            'Report Detail',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        actions: [
          Semantics(
            label: 'Notifications',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.primary),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
              tooltip: 'Notifications',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Semantics(
              label: 'Open profile menu',
              button: true,
              child: ProfilePopupMenu(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          color: AppColors.primary.withOpacity(0.06),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                // Title
                Semantics(
                  label: 'Report Title',
                  child: TextFormField(
                    initialValue: report.title,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                Semantics(
                  label: 'Report Description',
                  child: TextFormField(
                    initialValue: report.description,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    readOnly: true,
                  ),
                ),
                const SizedBox(height: 16),
                // Location
                Semantics(
                  label: 'Location',
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.location_on, color: AppColors.primary),
                      label: Text(report.location),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Status and Timestamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                        Semantics(
                          label: 'Status: ${report.status}',
                          child: Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor(report.status),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              report.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold)),
                        Semantics(
                          label: report.timestamp != null
                              ? 'Reported at ${formatDate(report.timestamp)}'
                              : 'No timestamp',
                          child: Text(
                            report.timestamp != null
                                ? formatDate(report.timestamp)
                                : '',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Image
                const Text('Image', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Semantics(
                  label: report.imageUrl != null && report.imageUrl!.isNotEmpty
                      ? 'Report image'
                      : 'No image attached',
                  child: report.imageUrl != null && report.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(report.imageUrl!),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(child: Text('No image')),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}