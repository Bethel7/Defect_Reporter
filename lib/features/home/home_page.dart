import 'package:defect_reporter/features/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import '../../core/common/bottom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/my_reports/presentation/my_reports_provider.dart';
import '../../features/report/data/report_repository_provider.dart';
import '../../core/common/profile_popup_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/common/notification_bell.dart';
import '../../core/utils/home_utils.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdAsync = ref.watch(userIdProvider);
    final profileAsync = ref.watch(profileProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.primary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            FontAwesomeIcons.clipboardList,
            color: theme.appBarTheme.foregroundColor ?? colorScheme.onPrimary,
            size: 22,
          ),
        ),
        title: Text(
          "Dashboard",
          style: theme.textTheme.titleLarge?.copyWith(
            color:
                theme.appBarTheme.titleTextStyle?.color ??
                colorScheme.onPrimary,
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
      body: ref
          .watch(myReportsAsyncProvider)
          .when(
            data: (reports) {
              // Calculate counts from the actual reports list
              final totalReports = reports.length;
              final resolvedReports = reports
                  .where(
                    (r) => parseReportStatus(r.status) == ReportStatus.resolved,
                  )
                  .length;
              final pendingReports = reports
                  .where(
                    (r) =>
                        parseReportStatus(r.status) == ReportStatus.inProgress,
                  )
                  .length;

              // Show the most recent 5 reports (or fewer if less exist)
              final recentReports = reports.reversed.take(5).toList()
                ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

              return RefreshIndicator(
                onRefresh: () async {
                  await ref.refresh(myReportsAsyncProvider.future);
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  children: [
                    const SizedBox(height: 16),
                    profileAsync.when(
                      loading: () => Text(
                        "Hello, ...",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      error: (e, _) => Text(
                        "Hello, User",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      data: (profile) {
                        String userName = profile.fullName;
                        if (userName.contains(' ')) {
                          userName = userName.split(' ').first;
                        }
                        return Text(
                          "Hello, $userName",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Welcome back! Here’s your activity summary.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _DashboardCardModern(
                            icon: FontAwesomeIcons.listCheck,
                            label: "Total Reports",
                            value: "$totalReports",
                            color: colorScheme.primary,
                            iconBg: theme.cardColor,
                            iconColor: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardCardModern(
                            icon: FontAwesomeIcons.clock,
                            label: "In Progress",
                            value: "$pendingReports",
                            color: const Color(0xFFF59E42),
                            iconBg: theme.cardColor,
                            iconColor: const Color(0xFFF59E42),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardCardModern(
                            icon: FontAwesomeIcons.check,
                            label: "Resolved",
                            value: "$resolvedReports",
                            color: const Color(0xFF4CAF50),
                            iconBg: theme.cardColor,
                            iconColor: const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Recent Submissions",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (recentReports.isEmpty)
                      Text(
                        "No recent reports.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ...recentReports.map((report) {
                      final status = parseReportStatus(report.status);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: theme.cardColor,
                        child: ListTile(
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: statusColor(status).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: statusIcon(status)),
                          ),
                          title: Text(
                            report.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            "Status: ${report.status}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 13,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          trailing: ReportStatusBadge(
                            status: status,
                            label: report.status,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/report-detail',
                              arguments: report,
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error loading user ID: $e')),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (colorScheme.brightness != Brightness.dark)
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
            decoration: BoxDecoration(
              color: colorScheme.brightness == Brightness.dark
                  ? colorScheme.surface
                  : iconBg,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 20)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
