import '../../report/data/report_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/custom_button.dart';
import '../../../features/report/data/report_model.dart';
import '../../../features/my_reports/presentation/my_reports_provider.dart';
import '../../../features/my_reports/presentation/report_detail_page.dart';

class ReportConfirmationPage extends ConsumerStatefulWidget {
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
  ConsumerState<ReportConfirmationPage> createState() =>
      _ReportConfirmationPageState();
}

class _ReportConfirmationPageState
    extends ConsumerState<ReportConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(reportRepositoryProvider);
    final userId = ref.watch(userIdProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: FutureBuilder<ReportModel?>(
          future: ref
              .read(
                myReportsProvider({
                  'repository': repository,
                  'userId': userId,
                }).notifier,
              )
              .fetchReportById(widget.reportId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final report = snapshot.data;
            if (report == null) {
              return const Center(child: Text('Report not found.'));
            }
            return Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  if (colorScheme.brightness != Brightness.dark)
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
                      color: colorScheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Submission Successful!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thank you for reporting the issue. Your report has been submitted successfully.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    color: theme.cardColor,
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
                            'Report ID: ${report.id}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Timestamp: ${report.timestamp}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
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
                                    ReportDetailPage(reportId: report.id),
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
                            foregroundColor: colorScheme.onSurface.withOpacity(
                              0.7,
                            ),
                            side: BorderSide(color: theme.dividerColor),
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
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
