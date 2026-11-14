import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_status.freezed.dart';

/// The app's location permission.
enum LocationPermissionStatus {
  /// Not asked yet, or denied once: the system dialog can still be shown.
  denied,

  /// Denied for good: only the system settings can change it.
  deniedForever,
  whileInUse,
  always
  ;

  bool get isGranted =>
      this == LocationPermissionStatus.whileInUse ||
      this == LocationPermissionStatus.always;
}

/// Everything that decides whether a position can be obtained.
@freezed
abstract class LocationStatus with _$LocationStatus {
  const factory LocationStatus({
    required LocationPermissionStatus permission,

    /// The device location service (GPS) is switched on.
    required bool serviceEnabled,
  }) = _LocationStatus;

  const LocationStatus._();

  /// Positions can be requested right now.
  bool get isReady => permission.isGranted && serviceEnabled;
}
