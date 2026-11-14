// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthStatus _$AuthStatusFromJson(Map<String, dynamic> json) => _AuthStatus(
  lastSuccessfulAuthAt: json['lastSuccessfulAuthAt'] == null
      ? null
      : DateTime.parse(json['lastSuccessfulAuthAt'] as String),
  failedAttempts: (json['failedAttempts'] as num?)?.toInt() ?? 0,
  lockedUntil: json['lockedUntil'] == null
      ? null
      : DateTime.parse(json['lockedUntil'] as String),
);

Map<String, dynamic> _$AuthStatusToJson(_AuthStatus instance) =>
    <String, dynamic>{
      'lastSuccessfulAuthAt': instance.lastSuccessfulAuthAt?.toIso8601String(),
      'failedAttempts': instance.failedAttempts,
      'lockedUntil': instance.lockedUntil?.toIso8601String(),
    };
