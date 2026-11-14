import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/features/settings/data/settings_repository_impl.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';

import '../../helpers/hive_test_helper.dart';

void main() {
  late Directory directory;
  late Box<String> box;

  setUp(() async {
    directory = await setUpHive();
    box = await Hive.openBox<String>('settings');
  });

  tearDown(() => tearDownHive(directory));

  test('load returns defaults when nothing is saved', () {
    final repository = SettingsRepositoryImpl(box);

    expect(repository.load(), const AppSettings());
  });

  test('saved settings survive a new repository instance', () async {
    const settings = AppSettings(
      themeMode: AppThemeMode.dark,
      autoLockDuration: AutoLockDuration.minutes5,
      biometricsEnabled: true,
      screenshotProtection: true,
    );

    await SettingsRepositoryImpl(box).save(settings);

    expect(SettingsRepositoryImpl(box).load(), settings);
  });
}
