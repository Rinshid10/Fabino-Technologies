import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/features/auth/domain/entities/auth_status.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_verification.dart';
import 'package:smart_access_security/features/auth/domain/repositories/auth_status_repository.dart';
import 'package:smart_access_security/features/auth/domain/repositories/pin_repository.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_throttle_policy.dart';

/// PIN verification with throttling, plus the record of successful logins.
class AuthService {
  const AuthService({
    required PinRepository pinRepository,
    required AuthStatusRepository statusRepository,
    required Clock clock,
    PinThrottlePolicy policy = const PinThrottlePolicy(),
  }) : _pinRepository = pinRepository,
       _statusRepository = statusRepository,
       _clock = clock,
       _policy = policy;

  final PinRepository _pinRepository;
  final AuthStatusRepository _statusRepository;
  final Clock _clock;
  final PinThrottlePolicy _policy;

  Future<AuthStatus> status() => _statusRepository.read();

  /// Checks [pin], updating the failure counter and lockout.
  Future<PinVerification> verifyPin(String pin) async {
    final now = _clock();
    final status = await _statusRepository.read();

    final lockedUntil = status.lockedUntil;
    if (lockedUntil != null && _policy.remainingLockout(status, now) != null) {
      return PinLockedOut(until: lockedUntil);
    }

    if (await _pinRepository.matches(pin)) {
      await _statusRepository.save(_policy.registerSuccess(status, now));
      return const PinAccepted();
    }

    final failed = _policy.registerFailure(status, now);
    await _statusRepository.save(failed);
    final newLockout = failed.lockedUntil;
    return newLockout != null
        ? PinLockedOut(until: newLockout)
        : PinRejected(attemptsLeft: _policy.attemptsLeft(failed));
  }

  /// Stores a new PIN and counts it as a successful authentication.
  Future<void> setPin(String pin) async {
    await _pinRepository.savePin(pin);
    await recordSuccess();
  }

  /// Records a successful authentication (PIN set-up or biometrics).
  Future<void> recordSuccess() async {
    final status = await _statusRepository.read();
    await _statusRepository.save(_policy.registerSuccess(status, _clock()));
  }
}
