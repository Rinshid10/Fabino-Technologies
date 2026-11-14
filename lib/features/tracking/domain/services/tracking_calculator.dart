import 'dart:math' as math;

import 'package:smart_access_security/core/utils/distance.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

/// Pure maths for tracking: distance, speed and how a session grows when
/// a new position arrives.
class TrackingCalculator {
  const TrackingCalculator(
    this._distanceBetween, {
    this.minimumMoveMeters = 2,
    this.maximumAccuracyMeters = 50,
  });

  final DistanceCalculator _distanceBetween;

  /// Smaller movements are GPS jitter and are not added to the route.
  final double minimumMoveMeters;

  /// Positions less accurate than this are not added to the route.
  final double maximumAccuracyMeters;

  /// Metres between two points.
  double distance(TrackPoint from, TrackPoint to) {
    return _distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Length of a whole route, in metres.
  double totalDistance(List<TrackPoint> points) {
    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += distance(points[i - 1], points[i]);
    }
    return total;
  }

  /// Speed between two points in metres per second, or 0 when no time
  /// passed between them.
  double speedBetween(TrackPoint from, TrackPoint to) {
    final seconds =
        to.timestamp.difference(from.timestamp).inMilliseconds / 1000;
    return seconds <= 0 ? 0 : distance(from, to) / seconds;
  }

  /// Current speed for [fix]: the device's own reading when it has one,
  /// otherwise computed from the [previous] recorded point.
  double currentSpeed(TrackPoint? previous, LocationFix fix) {
    if (fix.speed > 0 || previous == null) return fix.speed;
    return speedBetween(previous, _toPoint(fix, speed: 0));
  }

  /// Returns [session] updated for a new [fix].
  ///
  /// The fix is appended to the route only when it is accurate enough and
  /// far enough from the previous point; the mock-location flag is
  /// recorded either way.
  TrackingSession addFix(TrackingSession session, LocationFix fix) {
    final flagged = session.copyWith(
      hadMockedLocation: session.hadMockedLocation || fix.isMocked,
    );
    if (fix.accuracy > maximumAccuracyMeters) return flagged;

    final previous = session.points.lastOrNull;
    final point = _toPoint(fix, speed: currentSpeed(previous, fix));
    if (previous == null) return flagged.copyWith(points: [point]);

    final moved = distance(previous, point);
    if (moved < minimumMoveMeters) return flagged;

    return flagged.copyWith(
      points: [...session.points, point],
      distanceMeters: session.distanceMeters + moved,
      maxSpeed: math.max(session.maxSpeed, point.speed),
    );
  }

  static TrackPoint _toPoint(LocationFix fix, {required double speed}) {
    return TrackPoint(
      latitude: fix.latitude,
      longitude: fix.longitude,
      accuracy: fix.accuracy,
      speed: speed,
      timestamp: fix.timestamp,
    );
  }
}
