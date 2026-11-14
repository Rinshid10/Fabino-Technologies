import 'package:smart_access_security/core/utils/distance.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';

/// Direction in which a geofence boundary was crossed.
enum GeofenceTransitionType { enter, exit }

/// The user entered or left [geofence].
class GeofenceTransition {
  const GeofenceTransition({required this.geofence, required this.type});

  final Geofence geofence;
  final GeofenceTransitionType type;
}

/// Result of comparing one position against every geofence.
class GeofenceEvaluation {
  const GeofenceEvaluation({
    required this.geofences,
    required this.transitions,
    required this.hasChanges,
  });

  /// The geofences with their presence updated for the position.
  final List<Geofence> geofences;

  /// Boundary crossings that deserve a notification.
  final List<GeofenceTransition> transitions;

  /// Whether any presence changed and so needs saving.
  final bool hasChanges;
}

/// Detects geofence entry and exit.
///
/// Each geofence remembers its last inside / outside state. A transition
/// is reported only when that state flips, so staying inside (or outside)
/// never repeats a notification.
class GeofenceEvaluator {
  const GeofenceEvaluator(
    this._distanceBetween, {
    this.exitMarginMeters = 10,
    this.maximumAccuracyMeters = 100,
  });

  final DistanceCalculator _distanceBetween;

  /// Once inside, the user must go this far beyond the radius to count as
  /// outside. Stops GPS noise at the boundary from firing enter / exit
  /// repeatedly.
  final double exitMarginMeters;

  /// Positions less accurate than this are ignored: they could put the
  /// user on the wrong side of a boundary.
  final double maximumAccuracyMeters;

  GeofenceEvaluation evaluate(List<Geofence> geofences, LocationFix fix) {
    if (fix.accuracy > maximumAccuracyMeters) {
      return GeofenceEvaluation(
        geofences: geofences,
        transitions: const [],
        hasChanges: false,
      );
    }

    final updated = <Geofence>[];
    final transitions = <GeofenceTransition>[];
    for (final geofence in geofences) {
      final presence = _presenceAt(geofence, fix);
      final next = geofence.copyWith(presence: presence);
      updated.add(next);

      final type = _transition(from: geofence.presence, to: presence);
      if (type != null) {
        transitions.add(GeofenceTransition(geofence: next, type: type));
      }
    }

    return GeofenceEvaluation(
      geofences: updated,
      transitions: transitions,
      hasChanges: !_samePresence(geofences, updated),
    );
  }

  /// Metres from the centre of [geofence] to [fix].
  double distanceToCenter(Geofence geofence, LocationFix fix) {
    return _distanceBetween(
      geofence.latitude,
      geofence.longitude,
      fix.latitude,
      fix.longitude,
    );
  }

  GeofencePresence _presenceAt(Geofence geofence, LocationFix fix) {
    final distance = distanceToCenter(geofence, fix);
    final wasInside = geofence.presence == GeofencePresence.inside;
    final limit = geofence.radiusMeters + (wasInside ? exitMarginMeters : 0);
    return distance <= limit
        ? GeofencePresence.inside
        : GeofencePresence.outside;
  }

  /// A first evaluation that finds the user inside counts as an entry;
  /// finding them outside is not news.
  static GeofenceTransitionType? _transition({
    required GeofencePresence from,
    required GeofencePresence to,
  }) {
    if (from == to) return null;
    return switch (to) {
      GeofencePresence.inside => GeofenceTransitionType.enter,
      GeofencePresence.outside when from == GeofencePresence.inside =>
        GeofenceTransitionType.exit,
      _ => null,
    };
  }

  static bool _samePresence(List<Geofence> before, List<Geofence> after) {
    for (var i = 0; i < before.length; i++) {
      if (before[i].presence != after[i].presence) return false;
    }
    return true;
  }
}
