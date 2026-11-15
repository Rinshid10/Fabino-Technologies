import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/features/location/data/geolocator_location_repository.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/controllers/mock_location_monitor.dart';

import '../../helpers/fake_location_repository.dart';
import '../../helpers/fake_notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeLocationRepository location;
  late FakeNotificationService notifications;
  late ProviderContainer container;

  setUp(() async {
    location = FakeLocationRepository();
    notifications = FakeNotificationService();
    container = ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(location),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
    );
    addTearDown(container.dispose);

    container.read(mockLocationMonitorProvider);
    // Something else (tracking, geofences) keeps the stream running.
    await container.read(positionStreamServiceProvider).acquire(Object());
  });

  Future<void> emit({required bool isMocked}) async {
    location.emit(fixAt(0, 0, isMocked: isMocked));
    await pumpEventQueue();
  }

  test('real positions send nothing', () async {
    await emit(isMocked: false);
    await emit(isMocked: false);

    expect(notifications.shown, isEmpty);
  });

  test('the first mocked position sends one security alert', () async {
    await emit(isMocked: false);
    await emit(isMocked: true);

    final alert = notifications.shown.single;
    expect(alert.title, 'Mock location detected');
    expect(alert.channel, NotificationChannel.security);
    expect(alert.id, NotificationIds.mockLocation);
  });

  test('more mocked positions do not repeat the alert', () async {
    await emit(isMocked: true);
    await emit(isMocked: true);
    await emit(isMocked: true);

    expect(notifications.shown, hasLength(1));
  });

  test('alerts again when mocking returns after a real position', () async {
    await emit(isMocked: true);
    await emit(isMocked: false);
    await emit(isMocked: true);

    expect(notifications.shown, hasLength(2));
  });

  test('a one-off mocked fix on the map also alerts', () async {
    location.currentFix = fixAt(10, 20, isMocked: true);

    await container.read(currentLocationProvider.future);

    expect(notifications.titles, ['Mock location detected']);
  });
}
