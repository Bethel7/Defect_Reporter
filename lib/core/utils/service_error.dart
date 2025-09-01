import 'package:dio/dio.dart';

class ServiceError {
  final String message;
  final int? statusCode;
  final dynamic data;

  ServiceError(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

ServiceError handleDioError(DioException e) {
  if (e.response != null) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    String msg = 'Request failed';
    if (data is Map && data['Message'] != null) {
      msg = data['Message'];
    } else if (data is String && data.isNotEmpty) {
      msg = data;
    } else if (e.message != null) {
      msg = e.message!;
    }
    return ServiceError(msg, statusCode: status, data: data);
  } else {
    return ServiceError(e.message ?? 'Network error');
  }
}
