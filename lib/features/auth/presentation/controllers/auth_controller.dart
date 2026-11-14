import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/features/auth/data/auth_status_repository_impl.dart';
import 'package:smart_access_security/features/auth/data/local_auth_biometric_repository.dart';
import 'package:smart_access_security/features/auth/data/pin_repository_impl.dart';
import 'package:smart_access_security/features/auth/domain/entities/auth_status.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_result.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_status.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_verification.dart';
import 'package:smart_access_security/features/auth/domain/services/auth_service.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService(
    pinRepository: ref.watch(pinRepositoryProvider),
    statusRepository: ref.watch(authStatusRepositoryProvider),
    clock: ref.watch(clockProvider),
  );
}

/// Last successful authentication and wrong-PIN counters.
@riverpod
Future<AuthStatus> authStatus(Ref ref) {
  return ref.watch(authServiceProvider).status();
}

/// Biometric hardware and enrolment on this device.
@riverpod
Future<BiometricStatus> biometricStatus(Ref ref) {
  return ref.watch(biometricRepositoryProvider).getStatus();
}

@Riverpod(keepAlive: true)
AuthController authController(Ref ref) => AuthController(ref);

/// Actions the auth screens can perform. Keeps widgets free of auth logic.
class AuthController {
  const AuthController(this._ref);

  final Ref _ref;

  AuthService get _service => _ref.read(authServiceProvider);

  /// Checks [pin] and unlocks the app when it is correct.
  Future<PinVerification> unlockWithPin(String pin) async {
    final result = await verifyPin(pin);
    if (result is PinAccepted) _unlock();
    return result;
  }

  /// Checks [pin] without changing the lock state (used by "Change PIN").
  Future<PinVerification> verifyPin(String pin) async {
    final result = await _service.verifyPin(pin);
    _ref.invalidate(authStatusProvider);
    return result;
  }

  /// Shows the biometric prompt and unlocks the app on success.
  Future<BiometricResult> unlockWithBiometrics() async {
    final result = await authenticateWithBiometrics(
      reason: 'Unlock Smart Access & Location Security',
    );
    if (result.isSuccess) {
      await _service.recordSuccess();
      _ref.invalidate(authStatusProvider);
      _unlock();
    }
    return result;
  }

  /// Shows the biometric prompt without changing the lock state.
  Future<BiometricResult> authenticateWithBiometrics({required String reason}) {
    return _ref.read(biometricRepositoryProvider).authenticate(reason: reason);
  }

  /// Saves the first PIN or a replacement PIN.
  Future<void> savePin(String pin) async {
    await _service.setPin(pin);
    _ref.invalidate(authStatusProvider);
  }

  /// Ends first-launch set-up and shows the app.
  void completeSetup() => _unlock();

  void _unlock() => _ref.read(appLockProvider.notifier).unlock();
}
