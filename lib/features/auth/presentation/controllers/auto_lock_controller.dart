import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/features/auth/domain/services/auto_lock_manager.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';

part 'auto_lock_controller.g.dart';

/// Connects the [AutoLockManager] to the app: lifecycle events in, lock
/// commands out. Watched once by the root widget so it lives as long as
/// the app does.
@Riverpod(keepAlive: true)
AutoLockManager autoLock(Ref ref) {
  final manager = AutoLockManager(
    clock: ref.watch(clockProvider),
    readSetting: () => ref.read(settingsControllerProvider).autoLockDuration,
    isUnlocked: () => ref.read(appLockProvider) == AppLockState.unlocked,
    onLock: () => ref.read(appLockProvider.notifier).lock(),
  );

  // onHide / onShow fire when the app really leaves the screen, and not
  // for system dialogs (permission, biometric prompt) drawn on top of it.
  final lifecycle = AppLifecycleListener(
    onHide: manager.onBackgrounded,
    onShow: manager.onForegrounded,
  );

  ref
    ..listen(appLockProvider, (_, _) => manager.restartInactivityTimer())
    ..listen(
      settingsControllerProvider.select((s) => s.autoLockDuration),
      (_, _) => manager.restartInactivityTimer(),
    )
    ..onDispose(() {
      lifecycle.dispose();
      manager.dispose();
    });

  return manager;
}
