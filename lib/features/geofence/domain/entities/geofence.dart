import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence.freezed.dart';
part 'geofence.g.dart';

/// Whether the user was inside a geofence at the last evaluated position.
enum GeofencePresence {
  /// Not evaluated yet (new or just edited).
  unknown,
  inside,
  outside,
}

/// A circular zone on the map.
@freezed
abstract class Geofence with _$Geofence {
  const factory Geofence({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    required DateTime createdAt,

    /// Remembered between positions (and restarts) so a notification is
    /// sent only when the user actually crosses the boundary.
    @Default(GeofencePresence.unknown) GeofencePresence presence,
  }) = _Geofence;

  factory Geofence.fromJson(Map<String, dynamic> json) =>
      _$GeofenceFromJson(json);
}
