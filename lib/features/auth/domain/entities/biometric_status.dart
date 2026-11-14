import 'package:freezed_annotation/freezed_annotation.dart';

part 'biometric_status.freezed.dart';

/// A kind of biometric the device has enrolled.
enum BiometricKind { fingerprint, face, iris, strong, weak }

/// What the device can do biometrically right now.
@freezed
abstract class BiometricStatus with _$BiometricStatus {
  const factory BiometricStatus({
    /// The device has biometric hardware.
    required bool isSupported,

    /// Biometrics the user has enrolled in the system settings.
    @Default(<BiometricKind>[]) List<BiometricKind> enrolled,
  }) = _BiometricStatus;

  const BiometricStatus._();

  static const unsupported = BiometricStatus(isSupported: false);

  /// Biometric unlock can be offered.
  bool get isAvailable => isSupported && enrolled.isNotEmpty;
}
