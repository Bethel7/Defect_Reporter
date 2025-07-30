import 'dart:io';
import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/common/profile_popup_menu.dart';

class ReportDetailPage extends StatelessWidget {
  final String reportId;

  const ReportDetailPage({
    super.key,
    required this.reportId,
  });

  // Simulate fetching report
  Future<Map<String, dynamic>> fetchReportDetails(String reportId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    // returning dummy data
    return {
      'title': 'Broken Seat',
      'description': 'The seat in row 12A is broken and cannot be adjusted.',
      'location': 'Boeing 787 - Row 12A',
      'status': 'Pending',
      'timestamp': '2025-07-30 14:23',
      'imagePath': null, 
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Report Detail', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.yellow),
            onPressed: () {
               Navigator.pushNamed(context, '/notifications');
            },
          ),
          const ProfilePopupMenu(),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchReportDetails(reportId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormField(
                  initialValue: data['title'],
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: data['description'],
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.location_on, color: AppColors.primary),
                    label: Text(data['location']),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: null,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(data['status']),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(data['timestamp']),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Image', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (data['imagePath'] != null && (data['imagePath'] as String?)?.isNotEmpty == true)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(data['imagePath']),
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Text('No image')),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}