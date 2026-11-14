import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';

/// The router's redirect guard, as a pure function.
///
/// Returns the location to redirect to, or `null` to stay at [location].
/// * No PIN yet: everything goes to PIN set-up.
/// * Locked: everything goes to the lock screen, remembering [location].
/// * Unlocked: the lock / set-up screens go back to where the user was.
String? resolveLockRedirect({
  required AppLockState lockState,
  required Uri location,
}) {
  final path = location.path;

  switch (lockState) {
    case AppLockState.needsSetup:
      return path == Routes.setupPin ? null : Routes.setupPin;

    case AppLockState.locked:
      if (path == Routes.lock) return null;
      final hasOrigin = path != Routes.setupPin && path != Routes.dashboard;
      return Uri(
        path: Routes.lock,
        queryParameters: hasOrigin
            ? {Routes.fromParam: location.toString()}
            : null,
      ).toString();

    case AppLockState.unlocked:
      if (path == Routes.lock) {
        return location.queryParameters[Routes.fromParam] ?? Routes.dashboard;
      }
      return path == Routes.setupPin ? Routes.dashboard : null;
  }
}
