import 'dart:math' as math;

import 'package:smart_access_security/features/auth/domain/entities/auth_status.dart';

/// Rules that slow down PIN guessing.
///
/// The first [freeAttempts] - 1 wrong PINs cost nothing. From the
/// [freeAttempts]-th wrong PIN on, each failure starts a lockout that
/// doubles every time, up to [maxLockout].
class PinThrottlePolicy {
  const PinThrottlePolicy({
    this.freeAttempts = 5,
    this.baseLockout = const Duration(seconds: 30),
    this.maxLockout = const Duration(minutes: 15),
  });

  final int freeAttempts;
  final Duration baseLockout;
  final Duration maxLockout;

  /// Time left on the current lockout, or `null` when PIN entry is allowed.
  Duration? remainingLockout(AuthStatus status, DateTime now) {
    final until = status.lockedUntil;
    if (until == null || !until.isAfter(now)) return null;
    return until.difference(now);
  }

  /// Wrong PINs still allowed before the next lockout.
  int attemptsLeft(AuthStatus status) {
    return math.max(0, freeAttempts - status.failedAttempts);
  }

  AuthStatus registerFailure(AuthStatus status, DateTime now) {
    final failures = status.failedAttempts + 1;
    return status.copyWith(
      failedAttempts: failures,
      lockedUntil: failures >= freeAttempts
          ? now.add(_lockoutFor(failures))
          : null,
    );
  }

  AuthStatus registerSuccess(AuthStatus status, DateTime now) {
    return status.copyWith(
      failedAttempts: 0,
      lockedUntil: null,
      lastSuccessfulAuthAt: now,
    );
  }

  Duration _lockoutFor(int failures) {
    // Cap the exponent so the shift below cannot overflow.
    final doublings = math.min(failures - freeAttempts, 20);
    final lockout = baseLockout * (1 << doublings);
    return lockout > maxLockout ? maxLockout : lockout;
  }
}
