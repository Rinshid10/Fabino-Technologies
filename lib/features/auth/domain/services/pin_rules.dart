import 'package:smart_access_security/core/constants/app_constants.dart';

/// Checks that a new PIN is well-formed and not trivially guessable.
abstract final class PinRules {
  /// Returns why [pin] is not acceptable, or `null` when it is fine.
  static String? validate(String pin) {
    if (pin.length != kPinLength || int.tryParse(pin) == null) {
      return 'The PIN must be $kPinLength digits.';
    }
    if (_allSameDigit(pin)) {
      return 'Do not use the same digit $kPinLength times.';
    }
    if (_isSequence(pin, step: 1) || _isSequence(pin, step: -1)) {
      return 'Do not use a simple sequence such as 123456.';
    }
    return null;
  }

  static bool _allSameDigit(String pin) => pin.split('').toSet().length == 1;

  static bool _isSequence(String pin, {required int step}) {
    final digits = pin.codeUnits;
    for (var i = 1; i < digits.length; i++) {
      if (digits[i] - digits[i - 1] != step) return false;
    }
    return true;
  }
}
