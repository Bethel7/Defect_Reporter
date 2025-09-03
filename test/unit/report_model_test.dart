import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/features/report/data/report_model.dart';

void main() {
  group('ReportModel', () {
    test('fromJson and toJson roundtrip', () {
      final json = {
        'id': '1',
        'title': 'Test',
        'description': 'Desc',
        'location': 'HQ',
        'status': 'submitted',
        'imageUrl': 'img.png',
        'timestamp': DateTime.now().toIso8601String(),
        'latitude': 1.23,
        'longitude': 4.56,
        'locationName': 'HQ',
      };
      final model = ReportModel.fromJson(json);
      final json2 = model.toJson();
      expect(json2['id'], json['id']);
      expect(json2['title'], json['title']);
      expect(json2['description'], json['description']);
      expect(json2['location'], json['location']);
      expect(json2['status'], json['status']);
      expect(json2['imageUrl'], json['imageUrl']);
      expect(json2['locationName'], json['locationName']);
    });

    test('handles missing/extra fields gracefully', () {
      final json = {'id': '1', 'title': 'T'};
      final model = ReportModel.fromJson(json);
      expect(model.id, '1');
      expect(model.title, 'T');
    });
  });
}
