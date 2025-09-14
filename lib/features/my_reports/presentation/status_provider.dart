import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api_client.dart';

final statusListProvider = FutureProvider<List<String>>((ref) async {
  final dio = ApiClient().dio;
  final response = await dio.get('/api/status/active');
  final data = response.data['data'] as List;
  // Map to status names
  return data.map((s) => s['statusName'] as String).toList();
});
