import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_fix.freezed.dart';

/// One position reading from the device.
@freezed
abstract class LocationFix with _$LocationFix {
  const factory LocationFix({
    required double latitude,
    required double longitude,

    /// Estimated horizontal error, in metres.
    required double accuracy,

    /// Speed over ground, in metres per second (never negative).
    required double speed,
    required DateTime timestamp,

    /// The position came from a mock-location app, not real GPS.
    @Default(false) bool isMocked,
  }) = _LocationFix;
}

/// How trustworthy a position is, derived from its accuracy radius.
enum AccuracyLevel {
  good,
  fair,
  poor
  ;

  /// Up to 10 m is good, up to 30 m is fair, anything larger is poor.
  factory AccuracyLevel.fromMeters(double accuracy) {
    if (accuracy <= 10) return AccuracyLevel.good;
    if (accuracy <= 30) return AccuracyLevel.fair;
    return AccuracyLevel.poor;
  }
}
