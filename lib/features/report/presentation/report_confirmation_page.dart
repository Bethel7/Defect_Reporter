import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/theme/text_styles.dart';
import '../../../features/report/data/report_model.dart';
import '../../../features/my_reports/presentation/my_reports_provider.dart';
import '../../../features/my_reports/presentation/report_detail_page.dart';

class ReportConfirmationPage extends StatefulWidget {
  final String reportId;
  final String timestamp;
  final String submittedTitle;
  final String submittedDescription;
  final String submittedLocation;
  final String submittedImageUrl;

  const ReportConfirmationPage({
    super.key,
    required this.reportId,
    required this.timestamp,
    required this.submittedTitle,
    required this.submittedDescription,
    required this.submittedLocation,
    required this.submittedImageUrl,
  });

  @override
  State<ReportConfirmationPage> createState() => _ReportConfirmationPageState();
}

class _ReportConfirmationPageState extends State<ReportConfirmationPage> {
  ReportModel? _report;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    try {
      final report = await MyReportsNotifier().fetchReportById(widget.reportId);
      setState(() {
        _report = report;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : _error != null
              ? Text('Error: $_error')
              : _report == null
              ? const Text('Report not found.')
              : Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Submission Successful!',
                        textAlign: TextAlign.center,
                        style: TextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Thank you for reporting the issue. Your report has been submitted successfully.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report ID: ${_report!.id}',
                                style: TextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Timestamp: ${_report!.timestamp}',
                                style: TextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            child: CustomButton(
                              label: 'View Report',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ReportDetailPage(reportId: _report!.id),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 120,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFFBDBDBD),
                                side: const BorderSide(
                                  color: Color(0xFFBDBDBD),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF474747),
                                ),
                              ),
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
