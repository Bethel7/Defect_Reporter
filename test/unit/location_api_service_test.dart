import 'package:dio/dio.dart';
import 'package:defect_reporter/services/location_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group('LocationApiService', () {
    late MockDio mockDio;
    late LocationApiService service;

    setUp(() {
      mockDio = MockDio();
      service = LocationApiService(dio: mockDio);
    });

    test('getActiveLocations returns list on success (Data key)', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.data).thenReturn({
        'Data': [
          {'locationID': 1, 'locationName': 'HQ'},
          {'locationID': 2, 'locationName': 'Main Hub'},
        ],
      });
      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
      final result = await service.getActiveLocations();
      expect(result, isA<List>());
      expect(result.length, 2);
    });

    test('getActiveLocations returns list on success (data key)', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.data).thenReturn({
        'data': [
          {'locationID': 1, 'locationName': 'HQ'},
        ],
      });
      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
      final result = await service.getActiveLocations();
      expect(result, isA<List>());
      expect(result.length, 1);
    });

    test(
      'getActiveLocations returns empty list if data is not a list',
      () async {
        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.data).thenReturn({'Data': {}});
        when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
        final result = await service.getActiveLocations();
        expect(result, isEmpty);
      },
    );

    test('getActiveLocations throws on error response', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(400);
      when(() => mockResponse.data).thenReturn({'Message': 'fail'});
      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
      expect(() => service.getActiveLocations(), throwsA(isA<Exception>()));
    });
  });
}
