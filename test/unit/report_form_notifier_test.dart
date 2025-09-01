import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/features/report/presentation/report_form_provider.dart';
import 'package:defect_reporter/features/report/data/report_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRemoteDataSource extends Mock
    implements ReportRemoteDataSource {}

void main() {
  group('ReportFormNotifier', () {
    late ReportFormNotifier notifier;

    setUp(() {
      notifier = ReportFormNotifier();
    });

    test('initial state is empty and not submitting', () {
      final state = notifier.state;
      expect(state.title, '');
      expect(state.description, '');
      expect(state.locationId, isNull);
      expect(state.locationName, isNull);
      expect(state.imagePath, isNull);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
    });

    test('setTitle updates title', () {
      notifier.setTitle('Test Title');
      expect(notifier.state.title, 'Test Title');
    });

    test('setDescription updates description', () {
      notifier.setDescription('Test Description');
      expect(notifier.state.description, 'Test Description');
    });

    test('setLocation updates location', () {
      notifier.setLocation(1, 'Location 1');
      expect(notifier.state.locationId, 1);
      expect(notifier.state.locationName, 'Location 1');
    });

    test('setImagePath updates imagePath', () {
      notifier.setImagePath('path/to/image.png');
      expect(notifier.state.imagePath, 'path/to/image.png');
    });

    test('reset clears the form', () {
      notifier.setTitle('T');
      notifier.setDescription('D');
      notifier.setLocation(1, 'name');
      notifier.setImagePath('img');
      notifier.reset();
      final state = notifier.state;
      expect(state.title, '');
      expect(state.description, '');
      expect(state.locationId, isNull);
      expect(state.locationName, isNull);
      expect(state.imagePath, isNull);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
    });
  });
}
