import 'report_model.dart';
import 'package:dio/dio.dart';
import '../../../api_client.dart';

abstract class ReportRemoteDataSource {
  /// Submits multiple reports at once. Throws on error.
  Future<List<String>> submitMultipleReports(List<ReportModel> reports);

  /// Submits one or more reports. Throws on error.
  Future<List<String>> submitReports(List<ReportModel> reports);

  /// Fetches all reports for the user. Throws on error.
  Future<List<ReportModel>> getMyReports(String userId);

  /// Fetch a specific report by ID
  Future<ReportModel> getMyReportById(String id);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  @override
  Future<List<String>> submitMultipleReports(List<ReportModel> reports) async {
    // You can reuse the logic from submitReports or call it directly
    return await submitReports(reports);
  }

  @override
  Future<List<String>> submitReports(List<ReportModel> reports) async {
    try {
      final formData = FormData.fromMap({
        'Reports': reports.map((r) => r.toJson()).toList(),
      });
      final response = await _dio.post(
        '/api/reports/submit-multiple',
        data: formData,
      );
      if (response.statusCode == 200) {
        final List<dynamic> ids = response.data['ReportIds'] ?? [];
        return ids.map((e) => e.toString()).toList();
      } else {
        final isSingle = reports.length == 1;
        throw Exception(
          response.data['Message'] ??
              (isSingle
                  ? 'Failed to submit report'
                  : 'Failed to submit reports'),
        );
      }
    } catch (e) {
      final isSingle = reports.length == 1;
      throw Exception(
        'Network error: $e. ' +
            (isSingle ? 'Failed to submit report' : 'Failed to submit reports'),
      );
    }
  }

  final Dio _dio = ApiClient().dio;

  @override
  Future<List<ReportModel>> getMyReports(String userId) async {
    try {
      // If your API supports pagination, add query params here
      final response = await _dio.get(
        '/api/reports/my-reports',
        queryParameters: {'userId': userId},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['Data'] ?? [];
        return data.map((e) => ReportModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['Message'] ?? 'Failed to fetch reports');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<ReportModel> getMyReportById(String id) async {
    try {
      final response = await _dio.get('/api/reports/my-reports/$id');
      if (response.statusCode == 200) {
        final data = response.data['Data'];
        return ReportModel.fromJson(data);
      } else {
        throw Exception(response.data['Message'] ?? 'Failed to fetch report');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
