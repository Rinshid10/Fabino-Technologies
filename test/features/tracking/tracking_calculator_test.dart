import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';
import 'package:smart_access_security/features/tracking/domain/services/tracking_calculator.dart';

import '../../helpers/fake_location_repository.dart';

void main() {
  const calculator = TrackingCalculator(Geolocator.distanceBetween);
  final start = DateTime(2026, 11, 14, 10);

  TrackPoint point(double latitude, double longitude, {int seconds = 0}) {
    return TrackPoint(
      latitude: latitude,
      longitude: longitude,
      accuracy: 5,
      speed: 0,
      timestamp: start.add(Duration(seconds: seconds)),
    );
  }

  TrackingSession emptySession() {
    return TrackingSession(id: 's1', startedAt: start);
  }

  group('distance', () {
    test('one degree of latitude is about 111 km', () {
      expect(
        calculator.distance(point(0, 0), point(1, 0)),
        closeTo(111195, 200),
      );
    });

    test('identical points are zero metres apart', () {
      expect(calculator.distance(point(12.5, 77.5), point(12.5, 77.5)), 0);
    });

    test('total distance sums every leg of the route', () {
      final route = [point(0, 0), point(0, 0.001), point(0, 0.002)];
      final oneLeg = calculator.distance(route[0], route[1]);

      expect(calculator.totalDistance(route), closeTo(oneLeg * 2, 0.01));
      expect(oneLeg, closeTo(111.3, 0.5));
    });

    test('a route with fewer than two points has no distance', () {
      expect(calculator.totalDistance([]), 0);
      expect(calculator.totalDistance([point(1, 1)]), 0);
    });
  });

  group('speed', () {
    test('speed is distance divided by elapsed time', () {
      final from = point(0, 0);
      final to = point(0, 0.001, seconds: 10);

      expect(calculator.speedBetween(from, to), closeTo(11.13, 0.05));
    });

    test('speed is zero when no time has passed', () {
      expect(calculator.speedBetween(point(0, 0), point(0, 0.001)), 0);
    });

    test('the device speed is preferred when it has one', () {
      final fix = fixAt(0, 0.001, speed: 4.2);

      expect(calculator.currentSpeed(point(0, 0), fix), 4.2);
    });

    test('speed is computed when the device reports none', () {
      final fix = fixAt(
        0,
        0.001,
        timestamp: start.add(const Duration(seconds: 10)),
      );

      expect(calculator.currentSpeed(point(0, 0), fix), closeTo(11.13, 0.05));
    });

    test('average speed of a session', () {
      final session = TrackingSession(
        id: 's1',
        startedAt: start,
        endedAt: start.add(const Duration(seconds: 100)),
        distanceMeters: 500,
      );

      expect(session.averageSpeed, 5);
      expect(emptySession().averageSpeed, 0);
    });
  });

  group('addFix', () {
    test('the first accurate fix becomes the first point', () {
      final session = calculator.addFix(emptySession(), fixAt(10, 20));

      expect(session.points, hasLength(1));
      expect(session.distanceMeters, 0);
    });

    test('a moved fix extends the route, distance and top speed', () {
      var session = calculator.addFix(emptySession(), fixAt(0, 0));
      session = calculator.addFix(session, fixAt(0, 0.001, speed: 3));
      session = calculator.addFix(session, fixAt(0, 0.002, speed: 7));

      expect(session.points, hasLength(3));
      expect(session.distanceMeters, closeTo(222.6, 1));
      expect(session.maxSpeed, 7);
    });

    test('jitter below the minimum move is ignored', () {
      var session = calculator.addFix(emptySession(), fixAt(0, 0));
      // About 1.1 m east.
      session = calculator.addFix(session, fixAt(0, 0.00001));

      expect(session.points, hasLength(1));
      expect(session.distanceMeters, 0);
    });

    test('an inaccurate fix is not added to the route', () {
      final session = calculator.addFix(
        emptySession(),
        fixAt(0, 0, accuracy: 120),
      );

      expect(session.points, isEmpty);
    });

    test('a mocked fix flags the session, even when not recorded', () {
      final session = calculator.addFix(
        emptySession(),
        fixAt(0, 0, accuracy: 120, isMocked: true),
      );

      expect(session.hadMockedLocation, isTrue);
      expect(session.points, isEmpty);
    });

    test('the mock flag stays set after real fixes follow', () {
      var session = calculator.addFix(
        emptySession(),
        fixAt(0, 0, isMocked: true),
      );
      session = calculator.addFix(session, fixAt(0, 0.001));

      expect(session.hadMockedLocation, isTrue);
    });
  });

  test('duration runs from the start to the end or last point', () {
    final running = emptySession().copyWith(points: [point(0, 0, seconds: 42)]);
    final finished = running.copyWith(
      endedAt: start.add(const Duration(minutes: 5)),
    );

    expect(emptySession().duration, Duration.zero);
    expect(running.duration, const Duration(seconds: 42));
    expect(finished.duration, const Duration(minutes: 5));
  });
}
