import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_credential.freezed.dart';
part 'pin_credential.g.dart';

/// What is stored instead of the PIN: a salted, slow hash.
@freezed
abstract class PinCredential with _$PinCredential {
  const factory PinCredential({
    /// Base64 of the derived key.
    required String hash,

    /// Base64 of the random salt used for this PIN.
    required String salt,

    /// Work factor used when the hash was created.
    required int iterations,
  }) = _PinCredential;

  factory PinCredential.fromJson(Map<String, dynamic> json) =>
      _$PinCredentialFromJson(json);
}
