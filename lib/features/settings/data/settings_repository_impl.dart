import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/core/storage/hive_boxes.dart';
import 'package:smart_access_security/core/storage/json_box_store.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';
import 'package:smart_access_security/features/settings/domain/repositories/settings_repository.dart';

part 'settings_repository_impl.g.dart';

/// [SettingsRepository] that keeps the settings in a Hive box.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(Box<String> box)
    : _store = JsonBoxStore(
        box: box,
        fromJson: AppSettings.fromJson,
        toJson: (settings) => settings.toJson(),
      );

  final JsonBoxStore<AppSettings> _store;

  @override
  AppSettings load() {
    return _store.read(StorageKeys.appSettings) ?? const AppSettings();
  }

  @override
  Future<void> save(AppSettings settings) {
    return _store.write(StorageKeys.appSettings, settings);
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepositoryImpl(ref.watch(hiveBoxesProvider).settings);
}
