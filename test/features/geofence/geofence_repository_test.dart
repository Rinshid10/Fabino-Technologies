import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/features/geofence/data/geofence_repository_impl.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';

import '../../helpers/hive_test_helper.dart';

void main() {
  late Directory directory;
  late Box<String> box;
  late GeofenceRepositoryImpl repository;

  Geofence geofence(String id, {int createdOffsetMinutes = 0}) {
    return Geofence(
      id: id,
      name: 'Zone $id',
      latitude: 12.9716,
      longitude: 77.5946,
      radiusMeters: 250,
      createdAt: DateTime(
        2026,
        11,
        14,
      ).add(Duration(minutes: createdOffsetMinutes)),
      presence: GeofencePresence.inside,
    );
  }

  setUp(() async {
    directory = await setUpHive();
    box = await Hive.openBox<String>('geofences');
    repository = GeofenceRepositoryImpl(box);
  });

  tearDown(() => tearDownHive(directory));

  test('geofences survive a restart, presence included', () async {
    await repository.save(geofence('a'));

    expect(await GeofenceRepositoryImpl(box).getAll(), [geofence('a')]);
  });

  test('getAll returns the oldest geofence first', () async {
    await repository.save(geofence('c', createdOffsetMinutes: 20));
    await repository.save(geofence('a'));
    await repository.save(geofence('b', createdOffsetMinutes: 10));

    expect((await repository.getAll()).map((g) => g.id), ['a', 'b', 'c']);
  });

  test('saving the same id updates the geofence', () async {
    await repository.save(geofence('a'));
    await repository.save(geofence('a').copyWith(radiusMeters: 900));

    final all = await repository.getAll();
    expect(all.single.radiusMeters, 900);
  });

  test('saveAll writes several geofences at once', () async {
    await repository.saveAll([geofence('a'), geofence('b')]);

    expect(await repository.getAll(), hasLength(2));
  });

  test('delete removes one geofence and clear removes all', () async {
    await repository.saveAll([geofence('a'), geofence('b')]);

    await repository.delete('a');
    expect((await repository.getAll()).single.id, 'b');

    await repository.clear();
    expect(await repository.getAll(), isEmpty);
  });
}
