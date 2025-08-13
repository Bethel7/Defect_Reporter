import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'report_detail_page.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../../features/report/data/report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../my_reports/presentation/my_reports_provider.dart';

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

  List<String> getAllLocations(List<ReportModel> reports) => [
        'All',
        ...reports.map((r) => r.location).toSet(),
      ];

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

    final allLocations = getAllLocations(reportModels);

    List<ReportModel> filteredReports = reportModels.where((report) {
      final matchesStatus =
          _selectedStatus == 'All' || report.status.toLowerCase() == _selectedStatus.toLowerCase();
      final matchesLocation =
          _selectedLocation == 'All' || report.location == _selectedLocation;
      final matchesDate = matchesDateRange(report);
      final matchesSearch = report.title.toLowerCase().contains(
            _search.toLowerCase(),
          );
      return matchesStatus && matchesLocation && matchesDate && matchesSearch;
    }).toList();

    Color statusColor(String status) {
      switch (status) {
        case ReportModel.statusResolved:
          return Colors.green;
        case ReportModel.statusInProgress:
          return Colors.orange;
        case ReportModel.statusSubmitted:
        default:
          return Colors.blueGrey;
      }
    }

    String formatDate(DateTime? date) {
      if (date == null) return '';
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        title: Semantics(
          label: 'Previous Reports Page',
          header: true,
          child: Text(
            'Previous Reports',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        actions: [
          Semantics(
            label: 'Notifications',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.primary),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
              tooltip: 'Notifications',
            ),
          ),
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
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: 130,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 13),
                    items: _allStatuses
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedStatus = val!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedLocation,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 13),
                    items: allLocations
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc, overflow: TextOverflow.ellipsis)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedLocation = val!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedDateRange,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 13),
                    items: _dateRanges
                        .map((range) => DropdownMenuItem(
                              value: range,
                              child: Text(range, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedDateRange = val!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedStatus = 'All';
                        _selectedLocation = 'All';
                        _selectedDateRange = 'All';
                        _search = '';
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reset Filters'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                        return Semantics(
                          label:
                              '${report.title}, status: ${report.status}, reported on ${formatDate(report.timestamp)} at ${report.location}',
                          button: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.report,
                                color: AppColors.primary,
                              ),
                              title: Text(
                                report.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                              subtitle: Text(
                                'Reported on ${formatDate(report.timestamp)}\nLocation: ${report.location}',
                                style: const TextStyle(fontSize: 13),
                                overflow : TextOverflow.fade,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (report.status ==
                                      ReportModel.statusResolved)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  if (report.status ==
                                      ReportModel.statusInProgress)
                                    const Icon(
                                      Icons.hourglass_bottom,
                                      color: Colors.orange,
                                    ),
                                  if (report.status ==
                                      ReportModel.statusSubmitted)
                                    const Icon(
                                      Icons.send,
                                      color: Colors.blueGrey,
                                    ),
                                  Container(
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
                                      ),
                                    ),
                                  ),
                                ],
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