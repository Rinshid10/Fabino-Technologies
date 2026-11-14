/// Names of the Hive boxes used by the app.
abstract final class HiveBoxNames {
  static const settings = 'settings';
  static const geofences = 'geofences';
  static const sessions = 'tracking_sessions';
}

/// Keys used inside Hive boxes and secure storage.
abstract final class StorageKeys {
  static const appSettings = 'app_settings';
  static const installMarker = 'install_marker';
  static const pinCredential = 'pin_credential';
  static const authStatus = 'auth_status';
}

/// Limits for geofence radius, in metres.
abstract final class GeofenceLimits {
  static const double minRadius = 50;
  static const double maxRadius = 2000;
  static const double defaultRadius = 200;
}

/// Layout breakpoints, in logical pixels.
abstract final class Breakpoints {
  static const double tablet = 600;
  static const double maxContentWidth = 840;
}

/// Number of digits in the app PIN.
const int kPinLength = 6;
