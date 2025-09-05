import 'report_model.dart';
import 'package:dio/dio.dart';
import '../../../api_client.dart';

abstract class ReportRemoteDataSource {
  /// Submits multiple reports at once. Throws on error.
  Future<List<String>> submitMultipleReports(List<ReportModel> reports);

  /// Submits one or more reports. Throws on error.
  Future<List<String>> submitReports(List<ReportModel> reports);

  /// Fetches all reports for the user. Throws on error.
  Future<List<ReportModel>> getMyReports(int userId);

  /// Fetch a specific report by ID
  Future<ReportModel> getMyReportById(String id);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  @override
  Future<List<String>> submitMultipleReports(List<ReportModel> reports) async {
    // Use the batch endpoint for both single and multiple reports
    final formData = FormData();
    for (int i = 0; i < reports.length; i++) {
      final report = reports[i];
      formData.fields.addAll([
        MapEntry('reportDtos[' + i.toString() + '].Title', report.title),
        MapEntry(
          'reportDtos[' + i.toString() + '].Description',
          report.description,
        ),
        MapEntry(
          'reportDtos[' + i.toString() + '].LocationID',
          report.locationId?.toString() ?? '',
        ),
        MapEntry(
          'reportDtos[' + i.toString() + '].Latitude',
          report.latitude?.toString() ?? '',
        ),
        MapEntry(
          'reportDtos[' + i.toString() + '].Longitude',
          report.longitude?.toString() ?? '',
        ),
      ]);
      if (report.imageUrl.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'reportDtos[' + i.toString() + '].Image',
            await MultipartFile.fromFile(
              report.imageUrl,
              filename: report.imageUrl.split('/').last,
            ),
          ),
        );
      }
    }
    final response = await _dio.post(
      '/api/reports/submit-multiple',
      data: formData,
    );
    print(
      'SubmitMultipleReports response: status=${response.statusCode}, data=${response.data}',
    );
    if (response.statusCode == 200) {
      final ids =
          response.data['ReportIds'] ??
          response.data['reportIds'] ??
          response.data['ids'] ??
          [];
      return (ids as List).map((e) => e.toString()).toList();
    } else {
      throw Exception(response.data['Message'] ?? 'Failed to submit reports');
    }
  }

  @override
  Future<List<String>> submitReports(List<ReportModel> reports) async {
    return await submitMultipleReports(reports);
  }

  final Dio _dio = ApiClient().dio;

  @override
  Future<List<ReportModel>> getMyReports(int userId) async {
    try {
      final response = await _dio.get(
        '/api/reports/my-reports',
        queryParameters: {'userId': userId},
      );
      print('Raw API response: \\n${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['reports'] ??
            response.data['Reports'] ??
            response.data['Data'] ??
            response.data['data'] ??
            [];
        print('Parsed reports raw list: $data');
        final List<ReportModel> reports = data
            .map((e) => ReportModel.fromJson(e))
            .toList();
        print('Parsed reports as models: $reports');
        return reports;
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
        final data = response.data['Data'] ?? response.data['data'] ?? response.data[''];
        return ReportModel.fromJson(data);
      } else {
        throw Exception(response.data['Message'] ?? 'Failed to fetch report');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
