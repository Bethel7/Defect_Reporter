import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/core/utils/report_utils.dart';

void main() {
  group('ReportUtils', () {
    test('statusColor returns correct color for known statuses', () {
      expect(ReportUtils.statusColor('resolved'), isNotNull);
      expect(ReportUtils.statusColor('in progress'), isNotNull);
      expect(ReportUtils.statusColor('submitted'), isNotNull);
    });
    test('statusColor returns fallback for unknown status', () {
      expect(ReportUtils.statusColor('unknown'), isNotNull);
    });
  });
}
