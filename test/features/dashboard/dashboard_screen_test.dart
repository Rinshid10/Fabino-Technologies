import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/core/storage/secure_store.dart';
import 'package:smart_access_security/features/auth/data/local_auth_biometric_repository.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_status.dart';
import 'package:smart_access_security/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:smart_access_security/features/geofence/data/geofence_repository_impl.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/location/data/geocoding_repository_impl.dart';
import 'package:smart_access_security/features/location/data/geolocator_location_repository.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/domain/repositories/geocoding_repository.dart';
import 'package:smart_access_security/features/settings/data/settings_repository_impl.dart';
import 'package:smart_access_security/features/tracking/data/tracking_repository_impl.dart';

import '../../helpers/fake_location_repository.dart';
import '../../helpers/fake_notification_service.dart';
import '../../helpers/fakes.dart';
import '../../helpers/hive_test_helper.dart';

class _NoAddress implements GeocodingRepository {
  @override
  Future<String?> addressFor({
    required double latitude,
    required double longitude,
  }) async => null;
}

void main() {
  late Directory directory;
  late FakeLocationRepository location;
  late FakeBiometricRepository biometrics;
  late GeofenceRepositoryImpl geofences;

  /// Hive does real file I/O, which only completes inside `runAsync`.
  Future<void> pumpDashboard(WidgetTester tester, {Size? size}) async {
    if (size != null) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }
    late List<Box<String>> boxes;
    await tester.runAsync(() async {
      directory = await setUpHive();
      boxes = [
        await Hive.openBox<String>('settings'),
        await Hive.openBox<String>('geofences'),
        await Hive.openBox<String>('sessions'),
      ];
      geofences = GeofenceRepositoryImpl(boxes[1]);
      await geofences.save(
        Geofence(
          id: 'home',
          name: 'Home',
          latitude: 0,
          longitude: 0,
          radiusMeters: 100,
          createdAt: DateTime(2026, 11, 14),
        ),
      );
    });
    addTearDown(() => tester.runAsync(() => tearDownHive(directory)));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          secureStoreProvider.overrideWithValue(InMemorySecureStore()),
          biometricRepositoryProvider.overrideWithValue(biometrics),
          locationRepositoryProvider.overrideWithValue(location),
          geocodingRepositoryProvider.overrideWithValue(_NoAddress()),
          notificationServiceProvider.overrideWithValue(
            FakeNotificationService(),
          ),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepositoryImpl(boxes[0]),
          ),
          geofenceRepositoryProvider.overrideWithValue(geofences),
          trackingRepositoryProvider.overrideWithValue(
            TrackingRepositoryImpl(boxes[2]),
          ),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  setUp(() {
    location = FakeLocationRepository();
    biometrics = FakeBiometricRepository(
      status: const BiometricStatus(
        isSupported: true,
        enrolled: [BiometricKind.fingerprint],
      ),
    );
  });

  testWidgets('shows a card for every part of the security status', (
    tester,
  ) async {
    await pumpDashboard(tester, size: const Size(420, 1400));

    for (final title in [
      'Biometrics',
      'Last authentication',
      'Location permission',
      'GPS',
      'Current location',
      'Tracking',
      'Geofences',
    ]) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    expect(find.text('While using the app'), findsOneWidget);
    expect(find.text('On'), findsOneWidget);
    expect(find.text('10.000000, 20.000000'), findsOneWidget);
    expect(find.text('Not tracking'), findsOneWidget);
    expect(find.text('1 geofence'), findsOneWidget);
    expect(find.text('Never'), findsOneWidget);
    // Biometrics exist on the device but are switched off in settings.
    expect(find.text('Disabled'), findsOneWidget);
  });

  testWidgets('explains missing permission and GPS instead of failing', (
    tester,
  ) async {
    location
      ..permission = LocationPermissionStatus.deniedForever
      ..serviceEnabled = false;

    await pumpDashboard(tester, size: const Size(420, 1400));

    expect(find.text('Permanently denied'), findsOneWidget);
    expect(find.text('Off'), findsOneWidget);
    expect(find.text('Unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('lays out without overflow on a small phone and a tablet', (
    tester,
  ) async {
    await pumpDashboard(tester, size: const Size(320, 568));
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1024, 768);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
