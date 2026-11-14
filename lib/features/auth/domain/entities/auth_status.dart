import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_status.freezed.dart';
part 'auth_status.g.dart';

/// Authentication bookkeeping: last success and wrong-PIN throttling.
@freezed
abstract class AuthStatus with _$AuthStatus {
  const factory AuthStatus({
    DateTime? lastSuccessfulAuthAt,
    @Default(0) int failedAttempts,

    /// PIN entry is refused until this moment.
    DateTime? lockedUntil,
  }) = _AuthStatus;

  factory AuthStatus.fromJson(Map<String, dynamic> json) =>
      _$AuthStatusFromJson(json);
}
