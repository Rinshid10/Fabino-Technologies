import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/features/geofence/data/geofence_repository_impl.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_list_controller.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_monitor.dart';
import 'package:smart_access_security/features/location/data/geolocator_location_repository.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/tracking/data/tracking_repository_impl.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_controller.dart';

import '../../helpers/fake_location_repository.dart';
import '../../helpers/fake_notification_service.dart';
import '../../helpers/hive_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;
  late FakeLocationRepository location;
  late FakeNotificationService notifications;
  late GeofenceRepositoryImpl repository;
  late ProviderContainer container;

  final home = Geofence(
    id: 'home',
    name: 'Home',
    latitude: 0,
    longitude: 0,
    radiusMeters: 100,
    createdAt: DateTime(2026, 11, 14),
  );

  /// Starts the monitor and waits for it to settle.
  Future<void> startMonitor() async {
    container.listen(geofenceMonitorProvider, (_, _) {});
    await container.read(geofenceListControllerProvider.future);
    await pumpEventQueue();
  }

  Future<void> emit(double latitude, double longitude) async {
    location.emit(fixAt(latitude, longitude));
    await pumpEventQueue();
  }

  setUp(() async {
    directory = await setUpHive();
    location = FakeLocationRepository();
    notifications = FakeNotificationService();
    repository = GeofenceRepositoryImpl(await Hive.openBox<String>('g'));
    container = ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(location),
        notificationServiceProvider.overrideWithValue(notifications),
        geofenceRepositoryProvider.overrideWithValue(repository),
        trackingRepositoryProvider.overrideWithValue(
          TrackingRepositoryImpl(await Hive.openBox<String>('s')),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await pumpEventQueue();
    await tearDownHive(directory);
  });

  test('does not use location while there are no geofences', () async {
    await startMonitor();

    expect(location.activeSubscriptions, 0);
  });

  test('starts listening when the first geofence is added', () async {
    await startMonitor();

    await container.read(geofenceListControllerProvider.notifier).save(home);
    await pumpEventQueue();

    expect(location.activeSubscriptions, 1);
    expect(location.openedWithBackground, [false]);
  });

  test('stops listening when the last geofence is deleted', () async {
    await repository.save(home);
    await startMonitor();
    expect(location.activeSubscriptions, 1);

    await container.read(geofenceListControllerProvider.notifier).clear();
    await pumpEventQueue();

    expect(location.activeSubscriptions, 0);
  });

  test('does not listen without location permission', () async {
    location.permission = LocationPermissionStatus.denied;
    await repository.save(home);
    await startMonitor();

    expect(location.activeSubscriptions, 0);
  });

  test('notifies once on entry and once on exit', () async {
    await repository.save(home);
    await startMonitor();

    await emit(0, 0.002); // outside: nothing to report
    await emit(0, 0); // enter
    await emit(0, 0.0002); // still inside
    await emit(0, 0.0003); // still inside
    await emit(0, 0.002); // exit
    await emit(0, 0.003); // still outside

    expect(notifications.titles, ['Entered Home', 'Left Home']);
    expect(
      notifications.shown.every(
        (n) => n.channel == NotificationChannel.geofence,
      ),
      isTrue,
    );
  });

  test('the inside / outside state is saved for the next launch', () async {
    await repository.save(home);
    await startMonitor();

    await emit(0, 0);

    expect(
      (await repository.getAll()).single.presence,
      GeofencePresence.inside,
    );
  });

  test(
    'a saved "inside" state prevents a repeat entry after restart',
    () async {
      await repository.save(home.copyWith(presence: GeofencePresence.inside));
      await startMonitor();

      await emit(0, 0);

      expect(notifications.titles, isEmpty);
    },
  );

  test('monitoring and tracking together share one subscription', () async {
    await repository.save(home);
    await startMonitor();

    await container.read(trackingControllerProvider.notifier).start();
    await emit(0, 0);

    expect(location.activeSubscriptions, 1);
    expect(location.maxConcurrentSubscriptions, 1);
    expect(notifications.titles, contains('Entered Home'));
    expect(
      container.read(trackingControllerProvider).session!.points,
      hasLength(1),
    );

    await container.read(trackingControllerProvider.notifier).stop();
    // Geofences still need positions after tracking ends.
    expect(location.activeSubscriptions, 1);
    expect(location.maxConcurrentSubscriptions, 1);
  });
}
