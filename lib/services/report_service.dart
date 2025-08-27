import 'package:dio/dio.dart';
import '../features/report/data/report_model.dart';
import '../api_client.dart';

class ReportService {
  final Dio _dio = ApiClient().dio;

  /// Submit a new report (with image)
  Future<String> submitReport(FormData formData) async {
    final response = await _dio.post('/api/reports/submit', data: formData);
    if (response.statusCode == 200) {
      return response.data['ReportId']?.toString() ?? '';
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to submit report');
    }
  }

  /// Get all reports for the current user
  Future<List<ReportModel>> getMyReports() async {
    final response = await _dio.get('/api/reports/my-reports');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['Data'] ?? [];
      return data.map((e) => ReportModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to fetch reports');
    }
  }

  /// Get a specific report by ID for the current user
  Future<ReportModel> getMyReportById(String id) async {
    final response = await _dio.get('/api/reports/my-reports/$id');
    if (response.statusCode == 200) {
      final data = response.data['Data'];
      return ReportModel.fromJson(data);
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to fetch report');
    }
  }
}
