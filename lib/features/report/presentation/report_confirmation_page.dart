import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../features/my_reports/presentation/report_detail_page.dart';
import '../../../features/report/data/report_model.dart';


class ReportConfirmationPage extends StatelessWidget {
  final String reportId;
  final String timestamp;
  final String submittedTitle;
  final String submittedDescription;
  final String submittedLocation;
  final String? submittedImageUrl;

  const ReportConfirmationPage({
    super.key,
    required this.reportId,
    required this.timestamp,
    required this.submittedTitle,
    required this.submittedDescription,
    required this.submittedLocation,
    this.submittedImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Treat back button as cancel
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: AppColors.primary, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Submission Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thank you for reporting the issue. Your report has been submitted successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          'Report ID: $reportId',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Timestamp: $timestamp',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'View Report',
                                               
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportDetailPage(
                                  report: ReportModel(
                                    id: reportId,
                                    title: submittedTitle, 
                                    description: submittedDescription, 
                                    location: submittedLocation, 
                                    status: ReportModel.statusSubmitted,
                                    imageUrl: submittedImageUrl, 
                                    aiDepartment: null,
                                    aiSeverity: null,
                                    timestamp: DateTime.tryParse(timestamp),
                                  ),
                                ),
                              ),
                            );
                          },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          Navigator.popAndPushNamed(context, './home');
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}