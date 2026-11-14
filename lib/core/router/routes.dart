/// Route paths used across the app. Navigate with these, never raw strings.
abstract final class Routes {
  static const setupPin = '/setup-pin';
  static const lock = '/lock';
  static const locationPermission = '/location-permission';

  static const dashboard = '/dashboard';
  static const map = '/map';
  static const tracking = '/tracking';
  static const trackingHistory = '/tracking/history';
  static const geofences = '/geofences';
  static const newGeofence = '/geofences/new';
  static const settings = '/settings';
  static const changePin = '/settings/change-pin';

  static String sessionDetail(String id) => '/tracking/history/$id';

  static String editGeofence(String id) => '/geofences/$id/edit';

  /// Query parameter that remembers where to return after unlocking.
  static const fromParam = 'from';
}
