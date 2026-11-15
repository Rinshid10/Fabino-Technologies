import 'package:intl/intl.dart';

/// Pure helpers that turn raw values into display strings.
abstract final class Formatters {
  static final _dateTime = DateFormat('d MMM y, h:mm a');
  static final _fileStamp = DateFormat('yyyyMMdd_HHmmss');

  /// `850 m` below one kilometre, `1.24 km` above.
  static String distance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  /// Converts metres per second to `km/h` with one decimal.
  static String speed(double metersPerSecond) {
    final kmh = metersPerSecond <= 0 ? 0.0 : metersPerSecond * 3.6;
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  /// `HH:MM:SS`, never negative.
  static String duration(Duration value) {
    final safe = value.isNegative ? Duration.zero : value;
    String two(int n) => n.toString().padLeft(2, '0');
    final hours = two(safe.inHours);
    final minutes = two(safe.inMinutes.remainder(60));
    final seconds = two(safe.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  /// Six decimals is roughly 0.1 m of precision.
  static String coordinate(double value) => value.toStringAsFixed(6);

  /// `±12 m`.
  static String accuracy(double meters) => '±${meters.round()} m';

  /// `14 Nov 2026, 9:30 am`: the phone's local time on a 12-hour clock.
  static String dateTime(DateTime value) {
    return _dateTime
        .format(value.toLocal())
        .replaceFirst('AM', 'am')
        .replaceFirst('PM', 'pm');
  }

  /// A timestamp that is safe to use in a file name.
  static String fileStamp(DateTime value) => _fileStamp.format(value);
}
