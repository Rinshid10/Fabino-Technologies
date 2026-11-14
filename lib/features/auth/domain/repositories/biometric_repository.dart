import 'package:smart_access_security/features/auth/domain/entities/biometric_result.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_status.dart';

/// Access to the platform biometric prompt. Raw biometric data never
/// reaches the app; the system only reports success or failure.
abstract interface class BiometricRepository {
  Future<BiometricStatus> getStatus();

  /// Shows the system prompt with [reason] and reports the outcome.
  Future<BiometricResult> authenticate({required String reason});
}
