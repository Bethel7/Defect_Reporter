import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/common/bottom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/my_reports/presentation/my_reports_provider.dart';
import '../../core/common/profile_popup_menu.dart';
import '../../core/theme/text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/common/notification_bell.dart';
import '../../features/auth/presentation/login_provider.dart';

Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'resolved':
      return AppColors.primary;
    case 'in progress':
      return Color(0xFFF59E42);
    case 'submitted':
      return Color(0xFF64748B);
    default:
      return Colors.grey;
  }
}

Icon statusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'resolved':
      return Icon(
        FontAwesomeIcons.circleCheck,
        color: AppColors.primary,
        size: 18,
      );
    case 'in progress':
      return Icon(
        FontAwesomeIcons.triangleExclamation,
        color: Color(0xFFF59E42),
        size: 18,
      );
    case 'submitted':
      return Icon(
        FontAwesomeIcons.paperPlane,
        color: Color(0xFF64748B),
        size: 18,
      );
    default:
      return Icon(FontAwesomeIcons.circleInfo, color: Colors.grey, size: 18);
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(myReportsProvider);
    final reports = reportsState.reports;

    final user = ref.watch(currentUserProvider);
    final String userName = user?.fullName ?? "User";

    // Calculate counts from the actual reports list
    final totalReports = reports.length;
    final resolvedReports = reports
        .where((r) => r.status.toLowerCase() == 'resolved')
        .length;
    final pendingReports = reports
        .where((r) => r.status.toLowerCase() == 'in progress')
        .length;

    // Show the most recent 5 reports (or fewer if less exist)
    final recentReports = reports.reversed.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            FontAwesomeIcons.clipboardList,
            color: Colors.white,
            size: 22,
          ),
        ),
        title: Text(
          "Dashboard",
          style: TextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const NotificationBell(),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfilePopupMenu(),
          ),
        ],
        toolbarHeight: 64,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          const SizedBox(height: 16),
          Text(
            "Hello, $userName",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Welcome back! Here’s your activity summary.",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.text,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          // Dashboard cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _DashboardCardModern(
                  icon: FontAwesomeIcons.check,
                  label: "Total Reports",
                  value: "$totalReports",
                  color: AppColors.primary,
                  iconBg: const Color(0xFFE9EBEF),
                  iconColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DashboardCardModern(
                  icon: FontAwesomeIcons.circleCheck,
                  label: "Resolved",
                  value: "$resolvedReports",
                  color: AppColors.primary,
                  iconBg: const Color(0xFFE9EBEF),
                  iconColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DashboardCardModern(
                  icon: FontAwesomeIcons.clock,
                  label: "In Progress",
                  value: "$pendingReports",
                  color: Color(0xFFF59E42),
                  iconBg: const Color(0xFFE9EBEF),
                  iconColor: Color(0xFFF59E42),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "Recent Submissions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (recentReports.isEmpty)
            const Text(
              "No recent reports.",
              style: TextStyle(color: Colors.black54),
            ),
          ...recentReports.map(
            (report) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor(report.status).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: statusIcon(report.status)),
                ),
                title: Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 2,
                ),
                subtitle: Text(
                  "Status: ${report.status}",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                trailing: Container(
                  margin: const EdgeInsets.only(left: 8),
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
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/report-detail',
                    arguments: report,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}

// Modern dashboard card widget for summary stats
class _DashboardCardModern extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color iconBg;
  final Color iconColor;

  const _DashboardCardModern({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(child: Icon(icon, color: iconColor, size: 20)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF717182)),
          ),
        ],
      ),
    );
  }
}
