import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  late final CookieJar cookieJar;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(baseUrl: 'http://svdcbas02:8212/'));
    cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
  }
}