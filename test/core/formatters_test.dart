import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    test('distance uses metres below 1 km and kilometres above', () {
      expect(Formatters.distance(0), '0 m');
      expect(Formatters.distance(849.6), '850 m');
      expect(Formatters.distance(1240), '1.24 km');
    });

    test('speed converts m/s to km/h and never goes negative', () {
      expect(Formatters.speed(10), '36.0 km/h');
      expect(Formatters.speed(-1), '0.0 km/h');
    });

    test('duration is zero padded HH:MM:SS', () {
      expect(
        Formatters.duration(
          const Duration(hours: 1, minutes: 2, seconds: 3),
        ),
        '01:02:03',
      );
      expect(Formatters.duration(const Duration(seconds: -5)), '00:00:00');
    });

    test('coordinate keeps six decimals', () {
      expect(Formatters.coordinate(12.3456789), '12.345679');
    });

    test('accuracy rounds to whole metres', () {
      expect(Formatters.accuracy(12.4), '±12 m');
    });

    test('dateTime uses a 12-hour clock with am and pm', () {
      expect(
        Formatters.dateTime(DateTime(2026, 11, 15, 9, 5)),
        '15 Nov 2026, 9:05 am',
      );
      expect(
        Formatters.dateTime(DateTime(2026, 11, 15, 15, 30)),
        '15 Nov 2026, 3:30 pm',
      );
      expect(
        Formatters.dateTime(DateTime(2026, 11, 15, 12)),
        '15 Nov 2026, 12:00 pm',
      );
      expect(
        Formatters.dateTime(DateTime(2026, 11, 15)),
        '15 Nov 2026, 12:00 am',
      );
    });
  });
}
