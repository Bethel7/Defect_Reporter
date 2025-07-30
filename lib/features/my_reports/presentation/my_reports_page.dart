import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'report_detail_page.dart';
import '../../../core/common/profile_popup_menu.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  final List<Map<String, String>> _allReports = [
    {'title': 'Broken seat', 'date': '10th oct 2023', 'status': 'In progress'},
    {
      'title': 'Faulty air conditioner',
      'date': '10th oct 2023',
      'status': 'Resolved',
    },
    {
      'title': 'Delayed  Departure',
      'date': '10th oct 2023',
      'status': 'Resolved',
    },
  ];

  String _search = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredReports = _allReports
        .where(
          (report) =>
              report['title']!.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();

    Color statusColor(String status) {
      switch (status) {
        case 'Resolved':
          return AppColors.primary;
        case 'In progress':
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Previous Reports',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.yellow),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          const ProfilePopupMenu(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search report....',
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Reports list
            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(child: Text('No reports found.'))
                  : ListView.separated(
                      itemCount: filteredReports.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              report['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Reported on ${report['date']}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor(report['status']!),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                report['status']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                 context,
                               MaterialPageRoute(
                                 builder: (_) => ReportDetailPage(reportId: 'your_report_id_here'),
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
     bottomNavigationBar : const MainBottomAppBar(),
    );
  }
}
