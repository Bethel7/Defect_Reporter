import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/common/profile_popup_menu.dart';
import '../../core/common/bottom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = <Map<String, String>>[];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            Image.asset('assets/images/et_logo.png', height: 32),
            const SizedBox(width: 8),
            const Text('Home', style: TextStyle(color: AppColors.accent)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.accent),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          const ProfilePopupMenu(),
        ],
      ),
      body: reports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_chart,
                    size: 64,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No reports were made yet',
                    style: TextStyle(fontSize: 18, color: AppColors.primary),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Issue Reports'),
                  const Divider(),
                  const Text('Recent Submissions'),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: reports.map((report) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text(report['title'] ?? ''),
                            subtitle: Text(
                              'Reported on ${report['date'] ?? ''}',
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: report['status'] == 'Resolved'
                                    ? AppColors.primary
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                report['status'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}