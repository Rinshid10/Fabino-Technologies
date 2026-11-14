import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lock_controller.g.dart';

/// Whether the user may see the app's content.
enum AppLockState {
  /// No PIN exists yet (first launch).
  needsSetup,
  locked,
  unlocked,
}

/// Whether a PIN already existed when the app started.
/// Overridden in `bootstrap()`.
@Riverpod(keepAlive: true)
bool pinConfiguredAtStartup(Ref ref) {
  throw UnimplementedError(
    'pinConfiguredAtStartupProvider must be overridden.',
  );
}

/// The single source of truth for the lock state. The router redirects to
/// the lock screen whenever this is not [AppLockState.unlocked].
@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {
  @override
  AppLockState build() {
    return ref.watch(pinConfiguredAtStartupProvider)
        ? AppLockState.locked
        : AppLockState.needsSetup;
  }

  /// Locks an unlocked app. Does nothing during first-launch set-up.
  void lock() {
    if (state == AppLockState.unlocked) state = AppLockState.locked;
  }

  void unlock() => state = AppLockState.unlocked;
}
