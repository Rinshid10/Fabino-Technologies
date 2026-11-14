// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PinCredential _$PinCredentialFromJson(Map<String, dynamic> json) =>
    _PinCredential(
      hash: json['hash'] as String,
      salt: json['salt'] as String,
      iterations: (json['iterations'] as num).toInt(),
    );

Map<String, dynamic> _$PinCredentialToJson(_PinCredential instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'salt': instance.salt,
      'iterations': instance.iterations,
    };
