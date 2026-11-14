import 'package:latlong2/latlong.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';

/// Map helpers for [Geofence].
extension GeofenceX on Geofence {
  LatLng get center => LatLng(latitude, longitude);
}

/// Display text for [GeofencePresence].
extension GeofencePresenceX on GeofencePresence {
  String get label => switch (this) {
    GeofencePresence.unknown => 'Not checked yet',
    GeofencePresence.inside => 'Inside',
    GeofencePresence.outside => 'Outside',
  };
}
