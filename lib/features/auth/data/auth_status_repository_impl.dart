import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/core/storage/secure_store.dart';
import 'package:smart_access_security/features/auth/domain/entities/auth_status.dart';
import 'package:smart_access_security/features/auth/domain/repositories/auth_status_repository.dart';

part 'auth_status_repository_impl.g.dart';

/// [AuthStatusRepository] backed by secure storage, so the wrong-PIN
/// counter cannot be reset by editing app files.
class AuthStatusRepositoryImpl implements AuthStatusRepository {
  const AuthStatusRepositoryImpl(this._store);

  final SecureStore _store;

  @override
  Future<AuthStatus> read() async {
    final raw = await _store.read(StorageKeys.authStatus);
    if (raw == null) return const AuthStatus();
    return AuthStatus.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(AuthStatus status) {
    return _store.write(StorageKeys.authStatus, jsonEncode(status.toJson()));
  }
}

@Riverpod(keepAlive: true)
AuthStatusRepository authStatusRepository(Ref ref) {
  return AuthStatusRepositoryImpl(ref.watch(secureStoreProvider));
}
