import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/features/location/data/geolocator_location_repository.dart';
import 'package:smart_access_security/features/tracking/data/tracking_repository_impl.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';

import '../../helpers/fake_location_repository.dart';
import '../../helpers/fake_notification_service.dart';
import '../../helpers/hive_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;
  late FakeLocationRepository location;
  late FakeNotificationService notifications;
  late TrackingRepositoryImpl repository;
  late ProviderContainer container;
  late DateTime now;

  TrackingController controller() {
    return container.read(trackingControllerProvider.notifier);
  }

  TrackingState state() => container.read(trackingControllerProvider);

  setUp(() async {
    directory = await setUpHive();
    now = DateTime(2026, 11, 14, 10);
    location = FakeLocationRepository();
    notifications = FakeNotificationService();
    repository = TrackingRepositoryImpl(await Hive.openBox<String>('s'));
    container = ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(location),
        notificationServiceProvider.overrideWithValue(notifications),
        trackingRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => now),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await pumpEventQueue();
    await tearDownHive(directory);
  });

  test('starts idle', () {
    expect(state().isTracking, isFalse);
    expect(location.activeSubscriptions, 0);
  });

  test('start opens one background stream and notifies', () async {
    await controller().start();

    expect(state().isTracking, isTrue);
    expect(location.activeSubscriptions, 1);
    expect(location.openedWithBackground, [true]);
    expect(notifications.titles, ['Tracking started']);
  });

  test('starting twice does not create a second stream or session', () async {
    await controller().start();
    final firstId = state().session!.id;
    await controller().start();

    expect(state().session!.id, firstId);
    expect(location.maxConcurrentSubscriptions, 1);
    expect(location.openedWithBackground, hasLength(1));
  });

  test('incoming fixes build the route, distance and speed', () async {
    await controller().start();

    location
      ..emit(fixAt(0, 0))
      ..emit(fixAt(0, 0.001, speed: 6));
    await pumpEventQueue();

    final session = state().session!;
    expect(session.points, hasLength(2));
    expect(session.distanceMeters, closeTo(111.3, 0.5));
    expect(state().currentSpeed, 6);
    expect(state().lastFix, fixAt(0, 0.001, speed: 6));
  });

  test('a mocked fix flags the running session', () async {
    await controller().start();

    location.emit(fixAt(0, 0, isMocked: true));
    await pumpEventQueue();

    expect(state().session!.hadMockedLocation, isTrue);
  });

  test('stop saves the session, closes the stream and notifies', () async {
    await controller().start();
    location
      ..emit(fixAt(0, 0))
      ..emit(fixAt(0, 0.001));
    await pumpEventQueue();
    now = now.add(const Duration(minutes: 2));

    final saved = await controller().stop();

    expect(state().isTracking, isFalse);
    expect(location.activeSubscriptions, 0);
    expect(saved!.endedAt, now);
    expect(saved.duration, const Duration(minutes: 2));
    expect(await repository.getById(saved.id), saved);
    expect(notifications.titles.last, 'Tracking stopped');
    expect(await container.read(trackingHistoryProvider.future), [saved]);
  });

  test('stop without a session does nothing', () async {
    expect(await controller().stop(), isNull);
    expect(notifications.titles, isEmpty);
  });

  test('start, stop and start again never overlaps streams', () async {
    await controller().start();
    await controller().stop();
    await controller().start();

    expect(location.maxConcurrentSubscriptions, 1);
    expect(location.activeSubscriptions, 1);
  });

  test('a session interrupted by an app kill is closed at start-up', () async {
    final interrupted = TrackingSession(
      id: 'killed',
      startedAt: now,
      points: [
        TrackPoint(
          latitude: 0,
          longitude: 0,
          accuracy: 5,
          speed: 0,
          timestamp: now.add(const Duration(minutes: 7)),
        ),
      ],
    );
    await repository.save(interrupted);

    controller();
    await pumpEventQueue();

    final recovered = await repository.getById('killed');
    expect(recovered!.endedAt, now.add(const Duration(minutes: 7)));
  });
}
