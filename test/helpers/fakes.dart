import 'package:smart_access_security/core/storage/secure_store.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_result.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_status.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_credential.dart';
import 'package:smart_access_security/features/auth/domain/repositories/biometric_repository.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_hasher.dart';

/// [SecureStore] that keeps values in memory.
class InMemorySecureStore implements SecureStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

/// Instant, insecure [PinHasher] so tests do not wait for real hashing.
class FakePinHasher implements PinHasher {
  @override
  Future<PinCredential> hash(String pin) async {
    return PinCredential(hash: 'hash-of-$pin', salt: 'salt', iterations: 1);
  }

  @override
  Future<bool> verify(String pin, PinCredential credential) async {
    return credential.hash == 'hash-of-$pin';
  }
}

/// [BiometricRepository] with a scripted status and prompt result.
class FakeBiometricRepository implements BiometricRepository {
  FakeBiometricRepository({
    this.status = BiometricStatus.unsupported,
    this.result = BiometricResult.notAvailable,
  });

  BiometricStatus status;
  BiometricResult result;
  int promptCount = 0;

  @override
  Future<BiometricStatus> getStatus() async => status;

  @override
  Future<BiometricResult> authenticate({required String reason}) async {
    promptCount++;
    return result;
  }
}
