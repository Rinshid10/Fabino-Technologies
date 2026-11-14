import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/domain/services/position_stream_service.dart';

import '../../helpers/fake_location_repository.dart';

void main() {
  late FakeLocationRepository repository;
  late PositionStreamService service;

  setUp(() {
    repository = FakeLocationRepository();
    service = PositionStreamService(repository);
  });

  tearDown(() => service.dispose());

  test('no platform subscription exists without consumers', () {
    expect(service.isActive, isFalse);
    expect(repository.activeSubscriptions, 0);
  });

  test('several consumers share one platform subscription', () async {
    await service.acquire('tracking');
    await service.acquire('geofences');
    await service.acquire('map');

    expect(repository.activeSubscriptions, 1);
    expect(repository.openedWithBackground, hasLength(1));
  });

  test('acquiring twice with the same consumer does not duplicate', () async {
    await service.acquire('tracking');
    await service.acquire('tracking');
    await service.acquire('tracking');

    expect(repository.activeSubscriptions, 1);
    expect(repository.openedWithBackground, hasLength(1));
  });

  test('the stream stops only when the last consumer releases', () async {
    await service.acquire('tracking');
    await service.acquire('geofences');

    await service.release('tracking');
    expect(repository.activeSubscriptions, 1);

    await service.release('geofences');
    expect(repository.activeSubscriptions, 0);
    expect(service.isActive, isFalse);
  });

  test('every listener receives each fix exactly once', () async {
    final first = <LocationFix>[];
    final second = <LocationFix>[];
    service.fixes.listen(first.add);
    service.fixes.listen(second.add);
    await service.acquire('tracking');

    repository.emit(fixAt(1, 1));
    await pumpEventQueue();

    expect(first, hasLength(1));
    expect(second, hasLength(1));
    expect(service.lastFix, fixAt(1, 1));
  });

  test('switching to background never opens two streams', () async {
    await service.acquire('geofences');
    await service.acquire('tracking', background: true);

    expect(repository.openedWithBackground, [false, true]);
    expect(repository.activeSubscriptions, 1);
    expect(repository.maxConcurrentSubscriptions, 1);
  });

  test('releasing the background consumer leaves background', () async {
    await service.acquire('geofences');
    await service.acquire('tracking', background: true);
    await service.release('tracking');

    expect(repository.openedWithBackground, [false, true, false]);
    expect(repository.maxConcurrentSubscriptions, 1);
  });

  test('rapid acquire / release never overlaps subscriptions', () async {
    final pending = <Future<void>>[];
    for (var i = 0; i < 20; i++) {
      pending
        ..add(service.acquire('screen-$i', background: i.isEven))
        ..add(service.release('screen-$i'));
    }
    await Future.wait(pending);

    expect(repository.maxConcurrentSubscriptions, lessThanOrEqualTo(1));
    expect(repository.activeSubscriptions, 0);
  });

  test('restart reopens the stream for existing consumers only', () async {
    await service.restart();
    expect(repository.activeSubscriptions, 0);

    await service.acquire('tracking');
    await service.restart();

    expect(repository.openedWithBackground, hasLength(2));
    expect(repository.activeSubscriptions, 1);
    expect(repository.maxConcurrentSubscriptions, 1);
  });

  test('stream errors are forwarded to listeners', () async {
    final errors = <Object>[];
    service.fixes.listen((_) {}, onError: errors.add);
    await service.acquire('tracking');

    repository.emitError(StateError('gps off'));
    await pumpEventQueue();

    expect(errors, hasLength(1));
  });

  test('accuracy levels follow the 10 m and 30 m thresholds', () {
    expect(AccuracyLevel.fromMeters(4), AccuracyLevel.good);
    expect(AccuracyLevel.fromMeters(10), AccuracyLevel.good);
    expect(AccuracyLevel.fromMeters(10.1), AccuracyLevel.fair);
    expect(AccuracyLevel.fromMeters(30), AccuracyLevel.fair);
    expect(AccuracyLevel.fromMeters(31), AccuracyLevel.poor);
  });
}
