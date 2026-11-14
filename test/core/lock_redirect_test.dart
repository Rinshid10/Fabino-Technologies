import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/core/router/lock_redirect.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';

void main() {
  String? redirect(AppLockState lockState, String location) {
    return resolveLockRedirect(
      lockState: lockState,
      location: Uri.parse(location),
    );
  }

  group('no PIN yet', () {
    test('every route goes to PIN set-up', () {
      expect(redirect(AppLockState.needsSetup, '/dashboard'), Routes.setupPin);
      expect(redirect(AppLockState.needsSetup, '/lock'), Routes.setupPin);
    });

    test('the set-up screen stays put', () {
      expect(redirect(AppLockState.needsSetup, Routes.setupPin), isNull);
    });
  });

  group('locked', () {
    test('a deep route goes to the lock screen and is remembered', () {
      final target = redirect(AppLockState.locked, '/tracking/history/abc');

      final uri = Uri.parse(target!);
      expect(uri.path, Routes.lock);
      expect(uri.queryParameters[Routes.fromParam], '/tracking/history/abc');
    });

    test('the dashboard goes to the lock screen without an origin', () {
      expect(redirect(AppLockState.locked, '/dashboard'), Routes.lock);
    });

    test('the lock screen stays put', () {
      expect(redirect(AppLockState.locked, '/lock?from=%2Fmap'), isNull);
    });
  });

  group('unlocked', () {
    test('the lock screen returns to the remembered route', () {
      expect(redirect(AppLockState.unlocked, '/lock?from=%2Fmap'), '/map');
    });

    test('the lock screen falls back to the dashboard', () {
      expect(redirect(AppLockState.unlocked, '/lock'), Routes.dashboard);
    });

    test('PIN set-up continues to the dashboard', () {
      expect(redirect(AppLockState.unlocked, '/setup-pin'), Routes.dashboard);
    });

    test('normal routes are not redirected', () {
      expect(redirect(AppLockState.unlocked, '/settings'), isNull);
    });
  });
}
