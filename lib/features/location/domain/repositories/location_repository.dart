import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';

/// Access to the device's location service and permissions.
abstract interface class LocationRepository {
  Future<LocationPermissionStatus> checkPermission();

  /// Shows the system permission dialog when it can still be shown.
  Future<LocationPermissionStatus> requestPermission();

  Future<bool> isServiceEnabled();

  /// Emits whenever the user switches the location service on or off.
  Stream<bool> watchServiceEnabled();

  /// A single fresh position.
  ///
  /// Throws a `Failure` when the service is off, permission is missing or
  /// no position can be determined.
  Future<LocationFix> getCurrentFix();

  /// Continuous positions. With [background] the stream keeps running
  /// while the app is minimised (Android foreground service / iOS
  /// background location).
  ///
  /// Only `PositionStreamService` may listen to this, so the app never
  /// holds more than one platform subscription.
  Stream<LocationFix> watchPosition({required bool background});

  Future<void> openLocationSettings();

  Future<void> openAppSettings();
}
