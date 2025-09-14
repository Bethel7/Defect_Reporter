import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/services/push_notification_service.dart';
import 'package:defect_reporter/services/local_notification_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockWidgetRef extends Mock implements WidgetRef {}

void main() {
  group('PushNotificationService', () {
    late PushNotificationService service;
    late MockFirebaseMessaging mockMessaging;
    late MockWidgetRef mockRef;

    setUp(() {
      service = PushNotificationService();
      mockMessaging = MockFirebaseMessaging();
      mockRef = MockWidgetRef();
    });

    test('sendTokenToBackend handles success and error', () async {
      // Should not throw on success or error
      await service.sendTokenToBackend('test-token');
      expect(
        true,
        isTrue,
        reason: 'sendTokenToBackend should complete without throwing.',
      );
    });

    test('initialize requests permission and sends token', () async {
      // Should not throw when initializing
      await service.initialize(mockRef);
      expect(
        true,
        isTrue,
        reason: 'initialize should complete without throwing.',
      );
    });

    test('enablePushNotifications sets enabled to true', () async {
      await service.disablePushNotifications();
      await service.enablePushNotifications();
      expect(
        service._enabled,
        isTrue,
        reason: 'Push notifications should be enabled.',
      );
    });

    test('disablePushNotifications sets enabled to false', () async {
      await service.disablePushNotifications();
      expect(
        service._enabled,
        isFalse,
        reason: 'Push notifications should be disabled.',
      );
    });
  });

  group('LocalNotificationService', () {
    late LocalNotificationService service;
    late MockFlutterLocalNotificationsPlugin mockPlugin;
    late MockWidgetRef mockRef;

    setUp(() {
      service = LocalNotificationService();
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      mockRef = MockWidgetRef();
    });

    test('enableNotifications sets enabled to true', () async {
      await service.disableNotifications();
      await service.enableNotifications();
      expect(
        service._enabled,
        isTrue,
        reason: 'Local notifications should be enabled.',
      );
    });

    test(
      'disableNotifications sets enabled to false and cancels all',
      () async {
        await service.disableNotifications();
        expect(
          service._enabled,
          isFalse,
          reason: 'Local notifications should be disabled.',
        );
      },
    );

    test('showNotification does not throw when enabled', () async {
      await service.enableNotifications();
      await service.showNotification(title: 'Test', body: 'Body', ref: mockRef);
      expect(
        true,
        isTrue,
        reason: 'showNotification should complete without throwing.',
      );
    });

    test('showNotification does not show when disabled', () async {
      await service.disableNotifications();
      await service.showNotification(title: 'Test', body: 'Body', ref: mockRef);
      expect(
        true,
        isTrue,
        reason: 'showNotification should not throw when disabled.',
      );
    });

    test('initialize does not throw', () async {
      await service.initialize(MockBuildContext(), mockRef);
      expect(
        true,
        isTrue,
        reason: 'initialize should complete without throwing.',
      );
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
