import 'package:smart_access_security/features/auth/domain/entities/pin_credential.dart';

/// Turns a PIN into a [PinCredential] and checks a PIN against one.
abstract interface class PinHasher {
  /// Hashes [pin] with a fresh random salt.
  Future<PinCredential> hash(String pin);

  Future<bool> verify(String pin, PinCredential credential);
}
