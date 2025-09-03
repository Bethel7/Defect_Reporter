import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/features/report/presentation/report_form_provider.dart';
import 'package:defect_reporter/features/report/data/report_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_location_service.dart';

class MockReportRemoteDataSource extends Mock
    implements ReportRemoteDataSource {}

void main() {
  group('ReportFormNotifier', () {
    late ReportFormNotifier notifier;
    late MockLocationService mockLocationService;

    setUp(() {
      mockLocationService = MockLocationService();
      notifier = ReportFormNotifier(locationService: mockLocationService);
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

    test(
      'submit sets isSubmitting true, then false, and sets error on failure',
      () async {
        // Simulate LocationService throwing
        when(
          () => mockLocationService.getCurrentLocation(any()),
        ).thenThrow(Exception('location error'));
        final future = notifier.submit(any());
        // isSubmitting should be true right after submit is called
        expect(notifier.state.isSubmitting, isTrue);
        final result = await future;
        // isSubmitting should be false after submit completes
        expect(notifier.state.isSubmitting, isFalse);
        // Should set error (since submission will fail with location error)
        expect(notifier.state.error, contains('location error'));
        expect(result, isNull);
      },
    );

    // Optionally, test submit success if needed by returning a fake position
    // test('submit success sets isSubmitting and clears error', () async {
    //   when(() => mockLocationService.getCurrentLocation(any())).thenAnswer((_) async => FakePosition());
    //   // ...set up notifier fields as needed for a valid report...
    //   final context = _FakeBuildContext();
    //   final result = await notifier.submit(context);
    //   expect(notifier.state.isSubmitting, isFalse);
    //   expect(notifier.state.error, isNull);
    //   expect(result, isNotNull);
    // });
    // Helper fake context for submit

    test('reset after partial input', () {
      notifier.setTitle('T');
      notifier.reset();
      expect(notifier.state.title, '');
      expect(notifier.state.description, '');
      expect(notifier.state.locationId, isNull);
      expect(notifier.state.locationName, isNull);
      expect(notifier.state.imagePath, isNull);
      expect(notifier.state.isSubmitting, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('set fields to whitespace/empty', () {
      notifier.setTitle('   ');
      notifier.setDescription('');
      notifier.setLocation(0, '');
      notifier.setImagePath('   ');
      expect(notifier.state.title, '   ');
      expect(notifier.state.description, '');
      expect(notifier.state.locationId, 0);
      expect(notifier.state.locationName, '');
      expect(notifier.state.imagePath, '   ');
    });
  });
}
