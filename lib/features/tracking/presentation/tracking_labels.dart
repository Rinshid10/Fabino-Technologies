import 'package:latlong2/latlong.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

/// Map helpers for [TrackingSession].
extension TrackingSessionX on TrackingSession {
  /// The recorded points as map coordinates.
  List<LatLng> get route => [
    for (final point in points) LatLng(point.latitude, point.longitude),
  ];
}
