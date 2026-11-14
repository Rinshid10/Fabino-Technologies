import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/features/auth/domain/services/auto_lock_manager.dart';
import 'package:smart_access_security/features/auth/domain/services/auto_lock_policy.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';

void main() {
  group('AutoLockPolicy', () {
    const policy = AutoLockPolicy();

    test('"immediately" locks after any time in the background', () {
      expect(
        policy.shouldLockAfterBackground(
          AutoLockDuration.immediately,
          Duration.zero,
        ),
        isTrue,
      );
    });

    test('timed settings lock only once the timeout has passed', () {
      const setting = AutoLockDuration.seconds30;

      expect(
        policy.shouldLockAfterBackground(setting, const Duration(seconds: 29)),
        isFalse,
      );
      expect(
        policy.shouldLockAfterBackground(setting, const Duration(seconds: 30)),
        isTrue,
      );
    });

    test('"never" does not lock', () {
      expect(
        policy.shouldLockAfterBackground(
          AutoLockDuration.never,
          const Duration(days: 7),
        ),
        isFalse,
      );
      expect(policy.inactivityTimeout(AutoLockDuration.never), isNull);
    });

    test('inactivity timeout is at least one minute', () {
      expect(
        policy.inactivityTimeout(AutoLockDuration.immediately),
        const Duration(minutes: 1),
      );
      expect(
        policy.inactivityTimeout(AutoLockDuration.seconds30),
        const Duration(minutes: 1),
      );
      expect(
        policy.inactivityTimeout(AutoLockDuration.minutes5),
        const Duration(minutes: 5),
      );
    });
  });

  group('AutoLockManager', () {
    late AutoLockDuration setting;
    late bool unlocked;
    late int lockCount;

    /// Builds a manager whose clock follows the fake timeline.
    AutoLockManager build(FakeAsync async) {
      final start = DateTime(2026, 11, 14, 8);
      return AutoLockManager(
        clock: () => start.add(async.elapsed),
        readSetting: () => setting,
        isUnlocked: () => unlocked,
        onLock: () {
          lockCount++;
          unlocked = false;
        },
      );
    }

    setUp(() {
      setting = AutoLockDuration.minute1;
      unlocked = true;
      lockCount = 0;
    });

    test('locks when returning after the timeout', () {
      fakeAsync((async) {
        final manager = build(async)..onBackgrounded();
        async.elapse(const Duration(seconds: 61));
        manager.onForegrounded();

        expect(lockCount, 1);
      });
    });

    test('does not lock when returning before the timeout', () {
      fakeAsync((async) {
        final manager = build(async)..onBackgrounded();
        async.elapse(const Duration(seconds: 20));
        manager.onForegrounded();

        expect(lockCount, 0);
      });
    });

    test('"immediately" locks on every return', () {
      fakeAsync((async) {
        setting = AutoLockDuration.immediately;
        build(async)
          ..onBackgrounded()
          ..onForegrounded();

        expect(lockCount, 1);
      });
    });

    test('"never" does not lock after a long absence or idle time', () {
      fakeAsync((async) {
        setting = AutoLockDuration.never;
        final manager = build(async)
          ..restartInactivityTimer()
          ..onBackgrounded();
        async.elapse(const Duration(hours: 5));
        manager.onForegrounded();
        async.elapse(const Duration(hours: 5));

        expect(lockCount, 0);
      });
    });

    test('ignores background time while already locked', () {
      fakeAsync((async) {
        unlocked = false;
        final manager = build(async)..onBackgrounded();
        async.elapse(const Duration(minutes: 10));
        // The user unlocked with biometrics while the prompt covered the app.
        unlocked = true;
        manager.onForegrounded();

        expect(lockCount, 0);
      });
    });

    test('locks after in-app inactivity', () {
      fakeAsync((async) {
        build(async).restartInactivityTimer();
        async.elapse(const Duration(seconds: 59));
        expect(lockCount, 0);

        async.elapse(const Duration(seconds: 1));
        expect(lockCount, 1);
      });
    });

    test('user activity restarts the inactivity countdown', () {
      fakeAsync((async) {
        final manager = build(async)..restartInactivityTimer();
        async.elapse(const Duration(seconds: 50));
        manager.onUserActivity();
        async.elapse(const Duration(seconds: 50));
        expect(lockCount, 0);

        async.elapse(const Duration(seconds: 10));
        expect(lockCount, 1);
      });
    });

    test('the inactivity timer does not fire in the background', () {
      fakeAsync((async) {
        setting = AutoLockDuration.minutes5;
        final manager = build(async)
          ..restartInactivityTimer()
          ..onBackgrounded();
        async.elapse(const Duration(minutes: 2));
        expect(lockCount, 0);

        // Back within the timeout: the countdown starts again from zero.
        manager.onForegrounded();
        async.elapse(const Duration(minutes: 4));
        expect(lockCount, 0);
        async.elapse(const Duration(minutes: 1));
        expect(lockCount, 1);
      });
    });

    test('dispose cancels the pending inactivity lock', () {
      fakeAsync((async) {
        build(async)
          ..restartInactivityTimer()
          ..dispose();
        async.elapse(const Duration(minutes: 10));

        expect(lockCount, 0);
      });
    });
  });
}
