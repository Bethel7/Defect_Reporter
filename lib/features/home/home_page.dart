import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/common/bottom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/my_reports/presentation/my_reports_provider.dart';
import '../../core/common/profile_popup_menu.dart';
import '../../features/report/data/report_model.dart';

Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'resolved':
      return Colors.green;
    case 'in progress':
      return Colors.orange;
    case 'submitted':
      return Colors.blueGrey;
    default:
      return Colors.grey;
  }
}

Icon statusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'resolved':
      return Icon(Icons.check, color: statusColor(status));
    case 'in progress':
      return Icon(Icons.hourglass_bottom, color: statusColor(status));
    case 'submitted':
      return Icon(Icons.send, color: statusColor(status));
    default:
      return Icon(Icons.help_outline, color: statusColor(status));
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(myReportsProvider);
    final reports = reportsState.reports;

    final String userName = "Berhanu";

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.primary),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            tooltip: 'Notifications',
          ),
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: ProfilePopupMenu(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          const SizedBox(height: 8),
          Text(
            "Hello, $userName ",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Welcome back! Here’s your activity summary.",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          // Dashboard cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _DashboardCard(
                  icon: Icons.assignment_turned_in,
                  label: "Total Reports",
                  value: "$totalReports",
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DashboardCard(
                  icon: Icons.check_circle,
                  label: "Resolved",
                  value: "$resolvedReports",
                  color: statusColor(ReportModel.statusResolved),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DashboardCard(
                  icon: Icons.pending_actions,
                  label: "In Progress",
                  value: "$pendingReports",
                  color: statusColor(ReportModel.statusInProgress),
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
              child: ListTile(
                leading: Icon(Icons.report, color: AppColors.primary),
                title: Text(report.title, 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                overflow: TextOverflow.fade,
                softWrap: false,
                ),
                subtitle: Text("Status: ${report.status}", 
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                overflow: TextOverflow.fade,
                softWrap: false,),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    statusIcon(report.status),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
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
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
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

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}