import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'filter_dropdown.dart';
import '../../../core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/text_styles.dart';
import 'report_detail_page.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../../features/report/data/report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../my_reports/presentation/my_reports_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/common/notification_bell.dart';

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

  List<String> _allLocations = [
    'All',
    'Main Hub',
    'Headquarters',
    'Aviation Academy',
    'Cargo & Logistics Center',
    'MRO Facility',
  ];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('locations');
    setState(() {
      _allLocations = [
        'All',
        ...?_allLocations.skip(1), // keep defaults after 'All'
        ...?saved?.where((loc) => !_allLocations.contains(loc)),
      ].toSet().toList(); // remove duplicates
    });
  }

  List<String> get _allStatuses => [
    'All',
    ReportModel.statusSubmitted,
    ReportModel.statusInProgress,
    ReportModel.statusResolved,
  ];

  bool matchesDateRange(ReportModel report) {
    if (_selectedDateRange == 'All' || report.timestamp == null) return true;
    final now = DateTime.now();
    final diff = now.difference(report.timestamp!).inDays;
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
    final reports = ref.watch(myReportsProvider).reports;
    final List<ReportModel> reportModels = reports.cast<ReportModel>();

    List<ReportModel> filteredReports = reportModels.where((report) {
      final matchesStatus =
          _selectedStatus == 'All' ||
          report.status.toLowerCase() == _selectedStatus.toLowerCase();
      final matchesLocation =
          _selectedLocation == 'All' || report.location == _selectedLocation;
      final matchesDate = matchesDateRange(report);
      final matchesSearch = report.title.toLowerCase().contains(
        _search.toLowerCase(),
      );
      return matchesStatus && matchesLocation && matchesDate && matchesSearch;
    }).toList();

    String formatDate(DateTime? date) {
      if (date == null) return '';
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        title: Semantics(
          label: 'Previous Reports Page',
          header: true,
          child: Text(
            'Previous Reports',
            style: TextStyles.headlineMedium.copyWith(
              color: AppColors.text,
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
              child: ProfilePopupMenu(),
            ),
          ),
        ],
      ),
      body: Padding(
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
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search report...',
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
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
              child: filteredReports.isEmpty
                  ? const Center(
                      child: Text(
                        'No reports found.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredReports.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        // Home page card style, but with date/location
                        Color cardBg = Colors.white;
                        Color statusBg;
                        Color statusText;
                        IconData statusIcon;
                        Color statusIconColor;
                        String statusLabel = report.status;
                        if (report.status == ReportModel.statusResolved) {
                          statusBg = const Color(0xFF26D27E);
                          statusText = Colors.white;
                          statusIcon = FontAwesomeIcons.circleCheck;
                          statusIconColor = const Color(0xFF26D27E);
                        } else if (report.status ==
                            ReportModel.statusInProgress) {
                          statusBg = const Color(0xFFF59E42);
                          statusText = Colors.white;
                          statusIcon = FontAwesomeIcons.triangleExclamation;
                          statusIconColor = const Color(0xFFF59E42);
                        } else if (report.status ==
                            ReportModel.statusSubmitted) {
                          statusBg = const Color(0xFF64748B);
                          statusText = Colors.white;
                          statusIcon = FontAwesomeIcons.paperPlane;
                          statusIconColor = const Color(0xFF64748B);
                        } else {
                          statusBg = Colors.grey;
                          statusText = Colors.white;
                          statusIcon = FontAwesomeIcons.circleInfo;
                          statusIconColor = Colors.grey;
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: statusIconColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  statusIcon,
                                  color: statusIconColor,
                                  size: 20,
                                ),
                              ),
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  'Status: ${report.status}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                Text(
                                  'Reported on ${formatDate(report.timestamp)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                Text(
                                  'Location: ${report.location}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ],
                            ),
                            trailing: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(16),
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
                                      ReportDetailPage(report: report),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}
