import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_session.freezed.dart';
part 'tracking_session.g.dart';

/// One recorded position of a route.
@freezed
abstract class TrackPoint with _$TrackPoint {
  const factory TrackPoint({
    required double latitude,
    required double longitude,
    required double accuracy,

    /// Metres per second.
    required double speed,
    required DateTime timestamp,
  }) = _TrackPoint;

  factory TrackPoint.fromJson(Map<String, dynamic> json) =>
      _$TrackPointFromJson(json);
}

/// A tracking session: the route and its summary numbers.
@freezed
abstract class TrackingSession with _$TrackingSession {
  const factory TrackingSession({
    required String id,
    required DateTime startedAt,

    /// `null` while the session is still being recorded.
    DateTime? endedAt,
    @Default(0) double distanceMeters,

    /// Highest speed seen, in metres per second.
    @Default(0) double maxSpeed,

    /// At least one position came from a mock-location app.
    @Default(false) bool hadMockedLocation,
    @Default(<TrackPoint>[]) List<TrackPoint> points,
  }) = _TrackingSession;

  const TrackingSession._();

  factory TrackingSession.fromJson(Map<String, dynamic> json) =>
      _$TrackingSessionFromJson(json);

  bool get isCompleted => endedAt != null;

  /// Length of the session. For a running session this is the time up to
  /// the last recorded point.
  Duration get duration {
    final end = endedAt ?? (points.isEmpty ? startedAt : points.last.timestamp);
    final value = end.difference(startedAt);
    return value.isNegative ? Duration.zero : value;
  }

  /// Average speed in metres per second.
  double get averageSpeed {
    final seconds = duration.inMilliseconds / 1000;
    return seconds <= 0 ? 0 : distanceMeters / seconds;
  }
}
