import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter.baseflow.com/geolocator');

  group('LocationService', () {
    late LocationService service;
    late MockBuildContext context;

    setUp(() {
      service = LocationService();
      context = MockBuildContext();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test(
      'returns Position when services enabled and permission granted',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              switch (call.method) {
                case 'isLocationServiceEnabled':
                  return true;
                case 'checkPermission':
                  return 2; // LocationPermission.always
                case 'getCurrentPosition':
                  return {
                    'latitude': 1.0,
                    'longitude': 2.0,
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                    'accuracy': 1.0,
                    'altitude': 0.0,
                    'heading': 0.0,
                    'speed': 0.0,
                    'speed_accuracy': 0.0,
                  };
                default:
                  return null;
              }
            });
        final result = await service.getCurrentLocation(context);
        expect(result, isA<Position>());
      },
    );

    test('returns null when location services are disabled', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'isLocationServiceEnabled') return false;
            return null;
          });
      final result = await service.getCurrentLocation(context);
      expect(result, isNull);
    });

    test('returns null when permission denied', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'isLocationServiceEnabled') return true;
            if (call.method == 'checkPermission') return 0; // denied
            if (call.method == 'requestPermission') return 0; // denied
            return null;
          });
      final result = await service.getCurrentLocation(context);
      expect(result, isNull);
    });

    test('returns null when permission deniedForever', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'isLocationServiceEnabled') return true;
            if (call.method == 'checkPermission') return 1; // deniedForever
            return null;
          });
      final result = await service.getCurrentLocation(context);
      expect(result, isNull);
    });

    test('returns null when permission unableToDetermine', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'isLocationServiceEnabled') return true;
            if (call.method == 'checkPermission') return 3; // unableToDetermine
            return null;
          });
      final result = await service.getCurrentLocation(context);
      expect(result, isNull);
    });

    test('returns null on exception', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw Exception('fail');
          });
      final result = await service.getCurrentLocation(context);
      expect(result, isNull);
    });
  });
}
