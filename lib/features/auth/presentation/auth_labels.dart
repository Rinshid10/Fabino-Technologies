import 'package:smart_access_security/features/auth/domain/entities/biometric_status.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_verification.dart';

/// Display text for [BiometricKind].
extension BiometricKindX on BiometricKind {
  String get label => switch (this) {
    BiometricKind.fingerprint => 'Fingerprint',
    BiometricKind.face => 'Face',
    BiometricKind.iris => 'Iris',
    BiometricKind.strong => 'Strong biometric',
    BiometricKind.weak => 'Weak biometric',
  };
}

/// Display text for [BiometricStatus].
extension BiometricStatusX on BiometricStatus {
  /// `Fingerprint, Face` or an explanation of why nothing is available.
  String get summary {
    if (!isSupported) return 'Not supported on this device';
    if (enrolled.isEmpty) return 'None enrolled in device settings';
    return enrolled.map((kind) => kind.label).join(', ');
  }
}

/// Display text for [PinVerification].
extension PinVerificationX on PinVerification {
  /// Error to show under the PIN dots, or `null` when the PIN was accepted.
  String? get errorMessage => switch (this) {
    PinAccepted() => null,
    PinRejected(:final attemptsLeft) when attemptsLeft == 1 =>
      'Wrong PIN. 1 attempt left before a lockout.',
    PinRejected(:final attemptsLeft) =>
      'Wrong PIN. $attemptsLeft attempts left before a lockout.',
    PinLockedOut() => 'Too many wrong attempts.',
  };

  /// When a lockout ends, or `null` if there is none.
  DateTime? get lockedUntil => switch (this) {
    PinLockedOut(:final until) => until,
    _ => null,
  };
}
