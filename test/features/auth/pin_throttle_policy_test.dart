import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/features/auth/domain/entities/auth_status.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_throttle_policy.dart';

void main() {
  const policy = PinThrottlePolicy();
  final now = DateTime(2026, 11, 14, 12);

  AuthStatus failTimes(int count) {
    var status = const AuthStatus();
    for (var i = 0; i < count; i++) {
      status = policy.registerFailure(status, now);
    }
    return status;
  }

  test('the first four failures do not lock', () {
    final status = failTimes(4);

    expect(status.failedAttempts, 4);
    expect(status.lockedUntil, isNull);
    expect(policy.attemptsLeft(status), 1);
  });

  test('the fifth failure locks for the base duration', () {
    final status = failTimes(5);

    expect(status.lockedUntil, now.add(const Duration(seconds: 30)));
    expect(
      policy.remainingLockout(status, now),
      const Duration(seconds: 30),
    );
    expect(policy.attemptsLeft(status), 0);
  });

  test('each further failure doubles the lockout up to the cap', () {
    expect(failTimes(6).lockedUntil, now.add(const Duration(minutes: 1)));
    expect(failTimes(7).lockedUntil, now.add(const Duration(minutes: 2)));
    expect(failTimes(40).lockedUntil, now.add(const Duration(minutes: 15)));
  });

  test('a lockout ends once its time has passed', () {
    final status = failTimes(5);
    final later = now.add(const Duration(seconds: 30));

    expect(policy.remainingLockout(status, later), isNull);
  });

  test('success clears failures and records the time', () {
    final status = policy.registerSuccess(failTimes(6), now);

    expect(status.failedAttempts, 0);
    expect(status.lockedUntil, isNull);
    expect(status.lastSuccessfulAuthAt, now);
  });
}
