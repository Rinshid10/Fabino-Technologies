import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/features/settings/data/settings_repository_impl.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';

part 'settings_controller.g.dart';

/// Holds the current [AppSettings] and persists every change.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> setThemeMode(AppThemeMode mode) {
    return _update(state.copyWith(themeMode: mode));
  }

  Future<void> setAutoLockDuration(AutoLockDuration duration) {
    return _update(state.copyWith(autoLockDuration: duration));
  }

  Future<void> setBiometricsEnabled({required bool enabled}) {
    return _update(state.copyWith(biometricsEnabled: enabled));
  }

  Future<void> setScreenshotProtection({required bool enabled}) {
    return _update(state.copyWith(screenshotProtection: enabled));
  }

  Future<void> _update(AppSettings next) async {
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
