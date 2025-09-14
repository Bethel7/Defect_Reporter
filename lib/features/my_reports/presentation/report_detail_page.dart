import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/common/notification_bell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../report/data/report_model.dart';
import '../../../core/theme/input_borders.dart';
import '../../../core/utils/report_utils.dart';

class ReportDetailPage extends ConsumerWidget {
  final ReportModel report;
  const ReportDetailPage({super.key, required this.report});

  void _showFullImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
            ),
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: Semantics(
          label: 'Report Detail Page',
          header: true,
          child: Text(
            'Report Detail',
            style:
                theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ) ??
                TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
        ),
        actions: [
          NotificationBell(),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Semantics(
              label: 'Open profile menu',
              button: true,
              child: ProfilePopupMenu(),
            ),
          ),
        ],
        centerTitle: false,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.07),
            height: 1,
          ),
        ),
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
                  border: InputBorders.adaptive(color: AppColors.borderGray),
                  enabledBorder: InputBorders.adaptive(
                    color: AppColors.borderGray,
                  ),
                  focusedBorder: InputBorders.adaptive(
                    color: AppColors.success,
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
                  border: InputBorders.adaptive(color: AppColors.borderGray),
                  enabledBorder: InputBorders.adaptive(
                    color: AppColors.borderGray,
                  ),
                  focusedBorder: InputBorders.adaptive(
                    color: AppColors.success,
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
            // Location Name (from backend: locationName, fallback to location)
            Semantics(
              label: 'Location',
              child: TextFormField(
                initialValue:
                    (report.locationName != null &&
                        report.locationName!.isNotEmpty)
                    ? report.locationName!
                    : report.locationName,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: InputBorders.adaptive(color: AppColors.borderGray),
                  enabledBorder: InputBorders.adaptive(
                    color: AppColors.borderGray,
                  ),
                  focusedBorder: InputBorders.adaptive(
                    color: AppColors.success,
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
                          color: ReportUtils.statusColor(report.status),
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
                      label:
                          'Reported at ${ReportUtils.formatDate(report.timestamp)}',
                      child: Text(ReportUtils.formatDate(report.timestamp)),
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
              label: report.imageUrl.isNotEmpty
                  ? 'Report image'
                  : 'No image attached',
              child: report.imageUrl.isNotEmpty
                  ? GestureDetector(
                      onTap: () =>
                          _showFullImageDialog(context, report.imageUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          report.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 160,
                                color: AppColors.primary.withOpacity(0.1),
                                child: const Center(
                                  child: Text('Image not available'),
                                ),
                              ),
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
