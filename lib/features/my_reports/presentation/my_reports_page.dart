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
import '../../../features/report/data/report_repository_provider.dart';
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

  List<String> _allLocations = ['All']; // Will be populated from provider

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAll();
    });
  }

  Future<void> _refreshAll() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repository = ref.read(reportRepositoryProvider);
        final userId = await ref.read(userIdProvider.future);
        print('Flutter userId: $userId (${userId.runtimeType})');
        await ref
            .read(
              myReportsProvider({
                'repository': repository,
                'userId': userId,
              }).notifier,
            )
            .refreshReports();
      await _loadLocations();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadLocations() async {
    setState(() {
      _allLocations = ['All'];
    });
  }

  List<String> get _allStatuses => [
    'All',
    'Submitted',
    'In Progress',
    'Resolved',
  ];

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
    final repository = ref.watch(reportRepositoryProvider);
    final userIdAsync = ref.watch(userIdProvider);
    final locationsAsync = ref.watch(activeLocationsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return userIdAsync.when(
      data: (userId) {
        // Print userId and type for debug
        print('Flutter userId (build): $userId (${userId.runtimeType})');
        return locationsAsync.when(
          data: (locations) {
            _allLocations = [
              'All',
              ...locations
                  .map((l) => l.locationName)
                  .whereType<String>()
                  .where((name) => name.isNotEmpty),
            ];
            final reports = ref
                .watch(
                  myReportsProvider({
                    'repository': repository,
                    'userId': userId,
                  }),
                )
                .reports;
            final List<ReportModel> reportModels = reports.cast<ReportModel>();

            List<ReportModel> filteredReports = reportModels.where((report) {
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
                  label: 'Previous Reports Page',
                  header: true,
                  child: Text(
                    'Previous Reports',
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
                    padding: EdgeInsets.only(right: 16),
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
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      0.07,
                    ),
                    height: 1,
                  ),
                ),
              ),
              body: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search bar
                          Semantics(
                            label: 'Search Reports',
                            textField: true,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _search = value;
                                  });
                                },
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search report...',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: colorScheme.primary,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Filters
                          Row(
                            children: [
                              Expanded(
                                child: FilterDropdown(
                                  label: 'Status',
                                  value: _selectedStatus,
                                  items: _allStatuses,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedStatus = val!;
                                    });
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
                                    setState(() {
                                      _selectedLocation = val!;
                                    });
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
                                    setState(() {
                                      _selectedDateRange = val!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Reports list
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: _refreshAll,
                              child: filteredReports.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.inbox,
                                            size: 64,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.18),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'No reports found.',
                                            style:
                                                theme.textTheme.bodyLarge
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withOpacity(0.65),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ) ??
                                                TextStyle(
                                                  color: colorScheme.onSurface
                                                      .withOpacity(0.65),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Try adjusting your filters or create a new report.',
                                            style:
                                                theme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ) ??
                                                TextStyle(
                                                  color: colorScheme.onSurface
                                                      .withOpacity(0.45),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: filteredReports.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final report = filteredReports[index];
                                        Color cardBg = theme.cardColor;
                                        Color statusBg =
                                            ReportUtils.statusColor(
                                              report.status,
                                            );
                                        Color statusText = Colors.white;
                                        String statusLabel = report.status;
                                        IconData statusIcon;
                                        Color statusIconColor;
                                        if (report.status.toLowerCase() ==
                                            'resolved') {
                                          statusIcon =
                                              FontAwesomeIcons.circleCheck;
                                          statusIconColor = colorScheme.primary;
                                        } else if (report.status
                                                .toLowerCase() ==
                                            'in progress') {
                                          statusIcon = FontAwesomeIcons
                                              .triangleExclamation;
                                          statusIconColor = const Color(
                                            0xFFF59E42,
                                          );
                                        } else if (report.status
                                                .toLowerCase() ==
                                            'submitted') {
                                          statusIcon =
                                              FontAwesomeIcons.paperPlane;
                                          statusIconColor = const Color(
                                            0xFF64748B,
                                          );
                                        } else {
                                          statusIcon =
                                              FontAwesomeIcons.circleInfo;
                                          statusIconColor = Colors.grey;
                                        }
                                        return Semantics(
                                          label:
                                              'Report card for ${report.title}, status: ${report.status}, location: ${report.locationName}',
                                          button: true,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: cardBg,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              leading: Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                // Optionally add an image or icon here
                                              ),
                                              title: Text(
                                                report.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    report.locationName ?? '',
                                                    style: theme
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  Text(
                                                    report.status,
                                                    style: theme
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                              trailing: Container(
                                                margin: const EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: statusBg,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  statusLabel,
                                                  style: TextStyle(
                                                    color: statusText,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ReportDetailPage(
                                                          reportId: report.id,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
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
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, st) => Scaffold(
            body: Center(child: Text('Error loading locations: $e')),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) =>
          Scaffold(body: Center(child: Text('Error loading user ID: $e'))),
    );
  }
}
