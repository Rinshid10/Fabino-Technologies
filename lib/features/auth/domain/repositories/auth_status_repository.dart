import 'package:smart_access_security/features/auth/domain/entities/auth_status.dart';

/// Persists the [AuthStatus].
abstract interface class AuthStatusRepository {
  Future<AuthStatus> read();

  Future<void> save(AuthStatus status);
}
