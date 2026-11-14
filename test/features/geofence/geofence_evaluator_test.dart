import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/domain/services/geofence_evaluator.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';

import '../../helpers/fake_location_repository.dart';

void main() {
  const evaluator = GeofenceEvaluator(Geolocator.distanceBetween);

  /// A 100 m geofence centred on the equator at longitude 0.
  Geofence home({
    GeofencePresence presence = GeofencePresence.unknown,
    String id = 'home',
  }) {
    return Geofence(
      id: id,
      name: 'Home',
      latitude: 0,
      longitude: 0,
      radiusMeters: 100,
      createdAt: DateTime(2026, 11, 14),
      presence: presence,
    );
  }

  // At the equator 0.001 degrees of longitude is about 111 m.
  final center = fixAt(0, 0);
  final justInside = fixAt(0, 0.0008); // ~89 m
  final inExitMargin = fixAt(0, 0.00095); // ~106 m
  final outside = fixAt(0, 0.002); // ~222 m

  GeofenceEvaluation evaluate(Geofence geofence, LocationFix fix) {
    return evaluator.evaluate([geofence], fix);
  }

  group('entry', () {
    test('moving from outside to inside reports an entry', () {
      final result = evaluate(
        home(presence: GeofencePresence.outside),
        justInside,
      );

      expect(result.transitions.single.type, GeofenceTransitionType.enter);
      expect(result.geofences.single.presence, GeofencePresence.inside);
      expect(result.hasChanges, isTrue);
    });

    test('a first check that finds the user inside reports an entry', () {
      final result = evaluate(home(), center);

      expect(result.transitions.single.type, GeofenceTransitionType.enter);
    });

    test('a first check that finds the user outside reports nothing', () {
      final result = evaluate(home(), outside);

      expect(result.transitions, isEmpty);
      expect(result.geofences.single.presence, GeofencePresence.outside);
      expect(result.hasChanges, isTrue);
    });
  });

  group('exit', () {
    test('moving from inside to outside reports an exit', () {
      final result = evaluate(home(presence: GeofencePresence.inside), outside);

      expect(result.transitions.single.type, GeofenceTransitionType.exit);
      expect(result.geofences.single.presence, GeofencePresence.outside);
    });

    test('drifting just past the radius does not exit (hysteresis)', () {
      final result = evaluate(
        home(presence: GeofencePresence.inside),
        inExitMargin,
      );

      expect(result.transitions, isEmpty);
      expect(result.geofences.single.presence, GeofencePresence.inside);
    });

    test('the exit margin does not help someone enter', () {
      final result = evaluate(
        home(presence: GeofencePresence.outside),
        inExitMargin,
      );

      expect(result.transitions, isEmpty);
      expect(result.geofences.single.presence, GeofencePresence.outside);
    });
  });

  group('no repeated notifications', () {
    test('staying inside reports nothing', () {
      final result = evaluate(home(presence: GeofencePresence.inside), center);

      expect(result.transitions, isEmpty);
      expect(result.hasChanges, isFalse);
    });

    test('staying outside reports nothing', () {
      final result = evaluate(
        home(presence: GeofencePresence.outside),
        outside,
      );

      expect(result.transitions, isEmpty);
      expect(result.hasChanges, isFalse);
    });

    test('a walk in and out yields exactly one entry and one exit', () {
      final path = [outside, justInside, center, justInside, outside, outside];
      var geofences = [home()];
      final types = <GeofenceTransitionType>[];

      for (final fix in path) {
        final result = evaluator.evaluate(geofences, fix);
        geofences = result.geofences;
        types.addAll(result.transitions.map((t) => t.type));
      }

      expect(types, [
        GeofenceTransitionType.enter,
        GeofenceTransitionType.exit,
      ]);
    });
  });

  test('each geofence is evaluated independently', () {
    final far = home(id: 'far').copyWith(latitude: 1, name: 'Far');
    final result = evaluator.evaluate([
      home(presence: GeofencePresence.outside),
      far.copyWith(presence: GeofencePresence.inside),
    ], center);

    expect(result.transitions, hasLength(2));
    expect(result.transitions[0].geofence.id, 'home');
    expect(result.transitions[0].type, GeofenceTransitionType.enter);
    expect(result.transitions[1].geofence.id, 'far');
    expect(result.transitions[1].type, GeofenceTransitionType.exit);
  });

  test('a very inaccurate position changes nothing', () {
    final result = evaluate(
      home(presence: GeofencePresence.inside),
      fixAt(0, 0.002, accuracy: 500),
    );

    expect(result.transitions, isEmpty);
    expect(result.hasChanges, isFalse);
    expect(result.geofences.single.presence, GeofencePresence.inside);
  });

  test('no geofences means no transitions', () {
    final result = evaluator.evaluate([], center);

    expect(result.transitions, isEmpty);
    expect(result.hasChanges, isFalse);
  });
}
