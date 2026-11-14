/// Outcome of one biometric prompt.
enum BiometricResult {
  success,
  cancelled,
  failed,
  lockedOut,
  permanentlyLockedOut,
  notAvailable,
  notEnrolled,
  error
  ;

  bool get isSuccess => this == BiometricResult.success;

  /// Message to show next to the PIN pad, or `null` when none is needed.
  String? get message => switch (this) {
    BiometricResult.success => null,
    BiometricResult.cancelled => 'Biometric check cancelled. Enter your PIN.',
    BiometricResult.failed => 'Biometric not recognised. Enter your PIN.',
    BiometricResult.lockedOut =>
      'Too many biometric attempts. Enter your PIN and try again later.',
    BiometricResult.permanentlyLockedOut =>
      'Biometrics are locked. Unlock your device with its passcode to '
          're-enable them, then enter your PIN here.',
    BiometricResult.notAvailable =>
      'Biometrics are not available on this device. Enter your PIN.',
    BiometricResult.notEnrolled =>
      'No biometrics are set up on this device. Enter your PIN.',
    BiometricResult.error => 'Biometric check failed. Enter your PIN.',
  };
}
