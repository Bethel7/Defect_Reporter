import 'package:flutter/material.dart';
import '../../../core/common/bottom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        title: Text(
          'Cached Reports',
          style:
              theme.textTheme.titleLarge?.copyWith(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ) ??
              TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          ),
          tooltip: 'Back',
        ),
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
      body: RefreshIndicator(
        onRefresh: _loadCachedReports,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _cachedReports.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.folderOpen,
                      size: 56,
                      color: colorScheme.onSurface.withOpacity(0.18),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No cached reports.',
                      style:
                          theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ) ??
                          TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
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
                      color: theme.cardColor,
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
                                    style:
                                        theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ) ??
                                        TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: theme.colorScheme.onSurface,
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
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Offline',
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                        ) ??
                                        TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Location: ${report.locationName}',
                              style:
                                  theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ) ??
                                  TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Description: ${report.description}',
                              style:
                                  theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ) ??
                                  TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Saved: ${report.timestamp.toString()}',
                              style:
                                  theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ) ??
                                  TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
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
