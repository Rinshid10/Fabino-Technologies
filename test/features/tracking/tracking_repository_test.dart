import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/features/tracking/data/tracking_repository_impl.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

import '../../helpers/hive_test_helper.dart';

void main() {
  late Directory directory;
  late Box<String> box;
  late TrackingRepositoryImpl repository;
  final start = DateTime(2026, 11, 14, 10);

  TrackingSession session(String id, {int startOffsetMinutes = 0}) {
    final startedAt = start.add(Duration(minutes: startOffsetMinutes));
    return TrackingSession(
      id: id,
      startedAt: startedAt,
      endedAt: startedAt.add(const Duration(minutes: 3)),
      distanceMeters: 250.5,
      maxSpeed: 4.5,
      hadMockedLocation: true,
      points: [
        TrackPoint(
          latitude: 12.9716,
          longitude: 77.5946,
          accuracy: 6,
          speed: 1.5,
          timestamp: startedAt,
        ),
        TrackPoint(
          latitude: 12.9720,
          longitude: 77.5950,
          accuracy: 8,
          speed: 4.5,
          timestamp: startedAt.add(const Duration(minutes: 3)),
        ),
      ],
    );
  }

  setUp(() async {
    directory = await setUpHive();
    box = await Hive.openBox<String>('sessions');
    repository = TrackingRepositoryImpl(box);
  });

  tearDown(() => tearDownHive(directory));

  test('a saved session is read back unchanged, points included', () async {
    await repository.save(session('a'));

    expect(await repository.getById('a'), session('a'));
  });

  test('sessions survive a restart (new repository, same box)', () async {
    await repository.save(session('a'));

    final reopened = TrackingRepositoryImpl(box);
    expect(await reopened.getAll(), [session('a')]);
  });

  test('getAll returns the newest session first', () async {
    await repository.save(session('old'));
    await repository.save(session('new', startOffsetMinutes: 60));
    await repository.save(session('middle', startOffsetMinutes: 30));

    final ids = (await repository.getAll()).map((s) => s.id);
    expect(ids, ['new', 'middle', 'old']);
  });

  test('saving the same id replaces the session', () async {
    await repository.save(session('a'));
    await repository.save(session('a').copyWith(distanceMeters: 999));

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.single.distanceMeters, 999);
  });

  test('delete removes one session and clear removes all', () async {
    await repository.save(session('a'));
    await repository.save(session('b'));

    await repository.delete('a');
    expect((await repository.getAll()).single.id, 'b');
    expect(await repository.getById('a'), isNull);

    await repository.clear();
    expect(await repository.getAll(), isEmpty);
  });
}
