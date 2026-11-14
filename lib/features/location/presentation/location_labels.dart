import 'package:latlong2/latlong.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';

/// Display text for [AccuracyLevel].
extension AccuracyLevelX on AccuracyLevel {
  String get label => switch (this) {
    AccuracyLevel.good => 'Good',
    AccuracyLevel.fair => 'Fair',
    AccuracyLevel.poor => 'Poor',
  };
}

/// Display text for [LocationPermissionStatus].
extension LocationPermissionStatusX on LocationPermissionStatus {
  String get label => switch (this) {
    LocationPermissionStatus.denied => 'Not granted',
    LocationPermissionStatus.deniedForever => 'Permanently denied',
    LocationPermissionStatus.whileInUse => 'While using the app',
    LocationPermissionStatus.always => 'Always',
  };
}

/// Map helpers for [LocationFix].
extension LocationFixX on LocationFix {
  LatLng get latLng => LatLng(latitude, longitude);

  AccuracyLevel get accuracyLevel => AccuracyLevel.fromMeters(accuracy);
}
