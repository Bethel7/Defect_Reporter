import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/common/bottom_app_bar.dart';
import '../../../services/offline_storage_service.dart';
import '../../../features/report/data/report_model.dart';
import '../../my_reports/presentation/report_detail_page.dart';

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
      body: RefreshIndicator(
        onRefresh: _loadCachedReports,
        child: _loading
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailPage(reportId: report.id),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    report.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Offline',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Location: ${report.location}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Description: ${report.description}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Saved: ${report.timestamp.toString()}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: const MainBottomAppBar(),
    );
  }
}
