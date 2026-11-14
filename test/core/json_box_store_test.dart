import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/core/storage/json_box_store.dart';

import '../helpers/hive_test_helper.dart';

void main() {
  late Directory directory;
  late JsonBoxStore<Map<String, dynamic>> store;

  setUp(() async {
    directory = await setUpHive();
    store = JsonBoxStore(
      box: await Hive.openBox<String>('test'),
      fromJson: (json) => json,
      toJson: (value) => value,
    );
  });

  tearDown(() => tearDownHive(directory));

  test('read returns null for a missing key', () {
    expect(store.read('missing'), isNull);
  });

  test('write then read round-trips a value', () async {
    await store.write('a', {'name': 'Home', 'radius': 120.5});

    expect(store.read('a'), {'name': 'Home', 'radius': 120.5});
  });

  test('writeAll, readAll, delete and clear', () async {
    await store.writeAll({
      'a': {'n': 1},
      'b': {'n': 2},
    });
    expect(store.readAll(), hasLength(2));

    await store.delete('a');
    expect(store.readAll(), [
      {'n': 2},
    ]);

    await store.clear();
    expect(store.readAll(), isEmpty);
  });
}
