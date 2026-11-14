import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_result.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_status.dart';
import 'package:smart_access_security/features/auth/domain/repositories/biometric_repository.dart';

part 'local_auth_biometric_repository.g.dart';

/// [BiometricRepository] backed by the `local_auth` plugin.
class LocalAuthBiometricRepository implements BiometricRepository {
  const LocalAuthBiometricRepository(this._auth);

  final LocalAuthentication _auth;

  @override
  Future<BiometricStatus> getStatus() async {
    try {
      if (!await _auth.canCheckBiometrics) return BiometricStatus.unsupported;
      final enrolled = await _auth.getAvailableBiometrics();
      return BiometricStatus(
        isSupported: true,
        enrolled: enrolled.map(_toKind).toList(),
      );
    } on LocalAuthException {
      return BiometricStatus.unsupported;
    } on PlatformException {
      return BiometricStatus.unsupported;
    } on MissingPluginException {
      return BiometricStatus.unsupported;
    }
  }

  @override
  Future<BiometricResult> authenticate({required String reason}) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      return authenticated ? BiometricResult.success : BiometricResult.failed;
    } on LocalAuthException catch (exception) {
      return _toResult(exception.code);
    } on PlatformException {
      return BiometricResult.error;
    } on MissingPluginException {
      return BiometricResult.notAvailable;
    }
  }

  static BiometricKind _toKind(BiometricType type) => switch (type) {
    BiometricType.fingerprint => BiometricKind.fingerprint,
    BiometricType.face => BiometricKind.face,
    BiometricType.iris => BiometricKind.iris,
    BiometricType.strong => BiometricKind.strong,
    BiometricType.weak => BiometricKind.weak,
  };

  static BiometricResult _toResult(LocalAuthExceptionCode code) {
    return switch (code) {
      LocalAuthExceptionCode.userCanceled ||
      LocalAuthExceptionCode.systemCanceled ||
      LocalAuthExceptionCode.timeout ||
      LocalAuthExceptionCode.userRequestedFallback ||
      LocalAuthExceptionCode.authInProgress => BiometricResult.cancelled,
      LocalAuthExceptionCode.temporaryLockout => BiometricResult.lockedOut,
      LocalAuthExceptionCode.biometricLockout =>
        BiometricResult.permanentlyLockedOut,
      LocalAuthExceptionCode.noBiometricsEnrolled ||
      LocalAuthExceptionCode.noCredentialsSet => BiometricResult.notEnrolled,
      LocalAuthExceptionCode.noBiometricHardware ||
      LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable ||
      LocalAuthExceptionCode.uiUnavailable => BiometricResult.notAvailable,
      LocalAuthExceptionCode.deviceError ||
      LocalAuthExceptionCode.unknownError => BiometricResult.error,
    };
  }
}

@Riverpod(keepAlive: true)
BiometricRepository biometricRepository(Ref ref) {
  return LocalAuthBiometricRepository(LocalAuthentication());
}
