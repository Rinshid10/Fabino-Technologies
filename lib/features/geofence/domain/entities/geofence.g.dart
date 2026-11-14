// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Geofence _$GeofenceFromJson(Map<String, dynamic> json) => _Geofence(
  id: json['id'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  radiusMeters: (json['radiusMeters'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  presence:
      $enumDecodeNullable(_$GeofencePresenceEnumMap, json['presence']) ??
      GeofencePresence.unknown,
);

Map<String, dynamic> _$GeofenceToJson(_Geofence instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'radiusMeters': instance.radiusMeters,
  'createdAt': instance.createdAt.toIso8601String(),
  'presence': _$GeofencePresenceEnumMap[instance.presence]!,
};

const _$GeofencePresenceEnumMap = {
  GeofencePresence.unknown: 'unknown',
  GeofencePresence.inside: 'inside',
  GeofencePresence.outside: 'outside',
};
