import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/common/bottom_app_bar.dart';
import '../../../services/offline_storage_service.dart';
import '../../../features/report/data/report_model.dart';

class CachedReportsPage extends StatefulWidget {
  const CachedReportsPage({super.key});

  @override
  State<CachedReportsPage> createState() => _CachedReportsPageState();
}

class _CachedReportsPageState extends State<CachedReportsPage> {
  List<ReportModel> _cachedReports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCachedReports();
  }

  Future<void> _loadCachedReports() async {
    final reports = await OfflineStorageService().getOfflineReports();
    setState(() {
      _cachedReports = reports;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cached Reports',
          style: TextStyles.headlineMedium.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _cachedReports.isEmpty
          ? const Center(
              child: Text(
                'No cached reports.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _cachedReports.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = _cachedReports[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      report.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${report.location}'),
                        Text('Description: ${report.description}'),
                        Text(
                          'Saved: ${report.timestamp != null ? report.timestamp.toString() : ''}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}
