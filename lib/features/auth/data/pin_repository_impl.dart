import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/core/storage/secure_store.dart';
import 'package:smart_access_security/features/auth/data/pbkdf2_pin_hasher.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_credential.dart';
import 'package:smart_access_security/features/auth/domain/repositories/pin_repository.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_hasher.dart';

part 'pin_repository_impl.g.dart';

/// [PinRepository] that keeps only a salted hash, in secure storage.
class PinRepositoryImpl implements PinRepository {
  const PinRepositoryImpl({
    required SecureStore store,
    required PinHasher hasher,
  }) : _store = store,
       _hasher = hasher;

  final SecureStore _store;
  final PinHasher _hasher;

  @override
  Future<bool> hasPin() async => await _readCredential() != null;

  @override
  Future<void> savePin(String pin) async {
    final credential = await _hasher.hash(pin);
    await _store.write(
      StorageKeys.pinCredential,
      jsonEncode(credential.toJson()),
    );
  }

  @override
  Future<bool> matches(String pin) async {
    final credential = await _readCredential();
    if (credential == null) return false;
    return _hasher.verify(pin, credential);
  }

  @override
  Future<void> clear() => _store.delete(StorageKeys.pinCredential);

  Future<PinCredential?> _readCredential() async {
    final raw = await _store.read(StorageKeys.pinCredential);
    if (raw == null) return null;
    return PinCredential.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

@Riverpod(keepAlive: true)
PinHasher pinHasher(Ref ref) => Pbkdf2PinHasher();

@Riverpod(keepAlive: true)
PinRepository pinRepository(Ref ref) {
  return PinRepositoryImpl(
    store: ref.watch(secureStoreProvider),
    hasher: ref.watch(pinHasherProvider),
  );
}
