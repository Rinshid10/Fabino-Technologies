import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_credential.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_hasher.dart';

/// [PinHasher] using PBKDF2-HMAC-SHA256 with a 16-byte random salt.
///
/// Key derivation is deliberately slow, so it runs in a background isolate
/// to keep the UI responsive.
class Pbkdf2PinHasher implements PinHasher {
  Pbkdf2PinHasher({this.iterations = 50000, Random? random})
    : _random = random ?? Random.secure();

  static const _saltLength = 16;
  static const _keyBits = 256;

  final int iterations;
  final Random _random;

  @override
  Future<PinCredential> hash(String pin) async {
    final salt = List<int>.generate(_saltLength, (_) => _random.nextInt(256));
    final key = await _derive(pin, salt, iterations);
    return PinCredential(
      hash: base64Encode(key),
      salt: base64Encode(salt),
      iterations: iterations,
    );
  }

  @override
  Future<bool> verify(String pin, PinCredential credential) async {
    final key = await _derive(
      pin,
      base64Decode(credential.salt),
      credential.iterations,
    );
    return _constantTimeEquals(key, base64Decode(credential.hash));
  }

  static Future<List<int>> _derive(String pin, List<int> salt, int iterations) {
    return Isolate.run(() async {
      final algorithm = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: iterations,
        bits: _keyBits,
      );
      final key = await algorithm.deriveKeyFromPassword(
        password: pin,
        nonce: salt,
      );
      return key.extractBytes();
    });
  }

  /// Compares without returning early, so timing reveals nothing.
  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var difference = 0;
    for (var i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }
    return difference == 0;
  }
}
