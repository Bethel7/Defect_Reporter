import 'dart:io';
import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../report/data/report_model.dart';
import '../../../core/theme/text_styles.dart';

class ReportDetailPage extends StatelessWidget {
  void _showFullImageDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(imageFile, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  final ReportModel report;

  const ReportDetailPage({super.key, required this.report});

  Color statusColor(String status) {
    switch (status) {
      case ReportModel.statusResolved:
        return const Color(0xFF26D27E);
      case ReportModel.statusInProgress:
        return const Color(0xFFF59E42);
      case ReportModel.statusSubmitted:
        return const Color(0xFF64748B);
      default:
        return Colors.grey;
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
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Text(
          'Report Detail',
          style: TextStyles.headlineMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.bell,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfilePopupMenu(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title
            Semantics(
              label: 'Report Title',
              child: TextFormField(
                initialValue: report.title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGreen),
                  ),
                  labelStyle: const TextStyle(color: AppColors.borderGray),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 15, color: Color(0xFF252525)),
                readOnly: true,
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Semantics(
              label: 'Report Description',
              child: TextFormField(
                initialValue: report.description,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGreen),
                  ),
                  labelStyle: const TextStyle(color: AppColors.borderGray),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 15, color: Color(0xFF252525)),
                readOnly: true,
              ),
            ),
            const SizedBox(height: 16),
            // Location
            Semantics(
              label: 'Location',
              child: TextFormField(
                initialValue: report.location,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderGreen),
                  ),
                  labelStyle: const TextStyle(color: AppColors.borderGray),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 15, color: Color(0xFF252525)),
                readOnly: true,
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
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Semantics(
                      label: 'Status: ${report.status}',
                      child: Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
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
                    const Text(
                      'Timestamp',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                  ? GestureDetector(
                      onTap: () =>
                          _showFullImageDialog(context, File(report.imageUrl!)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(report.imageUrl!),
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}
