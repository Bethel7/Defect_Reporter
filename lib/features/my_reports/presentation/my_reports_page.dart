import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'filter_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'report_detail_page.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../../features/report/data/report_model.dart';
import '../../../core/utils/report_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../my_reports/presentation/my_reports_provider.dart';
import 'status_provider.dart';
import '../../../core/common/notification_bell.dart';
import '../../../features/report/presentation/location_provider.dart';

class MyReportsPage extends ConsumerStatefulWidget {
  const MyReportsPage({super.key});

  @override
  ConsumerState<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends ConsumerState<MyReportsPage> {
  final List<String> _dateRanges = [
    'All',
    'Last 7 days',
    'Last 14 days',
    'Last 30 days',
  ];
  String _selectedDateRange = 'All';
  String _search = '';
  String _selectedStatus = 'All';
  String _selectedLocation = 'All';
  List<String> _allLocations = ['All'];

  // Statuses are now fetched from backend, so remove hardcoded list

  bool matchesDateRange(ReportModel report) {
    if (_selectedDateRange == 'All') return true;
    final now = DateTime.now();
    final diff = now.difference(report.timestamp).inDays;
    switch (_selectedDateRange) {
      case 'Last 7 days':
        return diff <= 7;
      case 'Last 14 days':
        return diff <= 14;
      case 'Last 30 days':
        return diff <= 30;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final reportsAsync = ref.watch(myReportsAsyncProvider);
    final locationsAsync = ref.watch(activeLocationsProvider);

    return locationsAsync.when(
      data: (locations) {
        _allLocations = [
          'All',
          ...locations
              .map((l) => l.locationName)
              .whereType<String>()
              .where((name) => name.isNotEmpty),
        ];

        return reportsAsync.when(
          data: (reportModels) {
            final filteredReports = reportModels.where((report) {
              final matchesStatus =
                  _selectedStatus == 'All' ||
                  report.status.toLowerCase() == _selectedStatus.toLowerCase();
              final matchesLocation =
                  _selectedLocation == 'All' ||
                  report.locationName == _selectedLocation;
              final matchesDate = matchesDateRange(report);
              final matchesSearch = report.title.toLowerCase().contains(
                _search.toLowerCase(),
              );
              return matchesStatus &&
                  matchesLocation &&
                  matchesDate &&
                  matchesSearch;
            }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

            return _buildScaffold(
              context,
              theme,
              colorScheme,
              isDark,
              filteredReports,
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, st) => Scaffold(
            body: Center(
              child: Text(
                'Error loading reports: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(
        body: Center(
          child: Text(
            'Error loading locations: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    List<ReportModel> filteredReports,
  ) {
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
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            ),
          ),
        ),
        title: Semantics(
          label: 'Previous Reports Page',
          header: true,
          child: Text(
            'Previous Reports',
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        actions: [
          const NotificationBell(),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Semantics(
              label: 'Open profile menu',
              button: true,
              child: const ProfilePopupMenu(),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Semantics(
              label: 'Search Reports',
              textField: true,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.surface
                      : colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _search = value),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search report...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Filters
            Row(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final statusesAsync = ref.watch(statusListProvider);
                      return statusesAsync.when(
                        data: (statuses) => FilterDropdown(
                          label: 'Status',
                          value: _selectedStatus,
                          items: ['All', ...statuses],
                          onChanged: (val) {
                            setState(() => _selectedStatus = val!);
                          },
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, st) => FilterDropdown(
                          label: 'Status',
                          value: _selectedStatus,
                          items: ['All'],
                          onChanged: (val) {
                            setState(() => _selectedStatus = val!);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilterDropdown(
                    label: 'Location',
                    value: _selectedLocation,
                    items: _allLocations,
                    onChanged: (val) {
                      setState(() => _selectedLocation = val!);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilterDropdown(
                    label: 'Date',
                    value: _selectedDateRange,
                    items: _dateRanges,
                    onChanged: (val) {
                      setState(() => _selectedDateRange = val!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Reports list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.refresh(myReportsAsyncProvider.future);
                },
                child: filteredReports.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.18),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No reports found.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.65),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters or create a new report.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredReports.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final report = filteredReports[index];
                          return _buildReportCard(
                            context,
                            theme,
                            colorScheme,
                            report,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    ReportModel report,
  ) {
    final cardBg = theme.cardColor;
    final statusBg = ReportUtils.statusColor(report.status);
    final statusText = Colors.white;
    IconData statusIcon;
    if (report.status.toLowerCase() == 'resolved') {
      statusIcon = FontAwesomeIcons.circleCheck;
    } else if (report.status.toLowerCase() == 'in progress') {
      statusIcon = FontAwesomeIcons.triangleExclamation;
    } else if (report.status.toLowerCase() == 'submitted') {
      statusIcon = FontAwesomeIcons.paperPlane;
    } else {
      statusIcon = FontAwesomeIcons.circleInfo;
    }

    return Semantics(
      label:
          'Report card for ${report.title}, status: ${report.status}, location: ${report.locationName}',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ReportDetailPage(report: report)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status icon
              Padding(
                padding: const EdgeInsets.only(right: 14, top: 2),
                child: Icon(statusIcon, color: statusBg, size: 30),
              ),
              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            report.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        // Status container (top right, not edge)
                        Container(
                          margin: const EdgeInsets.only(left: 8, top: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            report.status,
                            style: TextStyle(
                              color: statusText,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      report.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (report.locationName != null &&
                            report.locationName!.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                report.locationName!,
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(width: 14),
                            ],
                          ),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ReportUtils.formatDate(report.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
