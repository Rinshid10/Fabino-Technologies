// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackPoint _$TrackPointFromJson(Map<String, dynamic> json) => _TrackPoint(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  accuracy: (json['accuracy'] as num).toDouble(),
  speed: (json['speed'] as num).toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$TrackPointToJson(_TrackPoint instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'speed': instance.speed,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_TrackingSession _$TrackingSessionFromJson(Map<String, dynamic> json) =>
    _TrackingSession(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
      maxSpeed: (json['maxSpeed'] as num?)?.toDouble() ?? 0,
      hadMockedLocation: json['hadMockedLocation'] as bool? ?? false,
      points:
          (json['points'] as List<dynamic>?)
              ?.map((e) => TrackPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TrackPoint>[],
    );

Map<String, dynamic> _$TrackingSessionToJson(_TrackingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'distanceMeters': instance.distanceMeters,
      'maxSpeed': instance.maxSpeed,
      'hadMockedLocation': instance.hadMockedLocation,
      'points': instance.points.map((e) => e.toJson()).toList(),
    };
