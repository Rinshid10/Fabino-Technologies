import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/presentation/geofence_labels.dart';

/// One circle to draw: centre, radius and an optional name.
typedef GeofenceCircle = ({LatLng center, double radiusMeters, String? label});

/// Draws geofences as translucent circles with their names.
class GeofenceLayer extends StatelessWidget {
  const GeofenceLayer({required this.circles, this.color, super.key});

  /// Convenience constructor for saved geofences.
  GeofenceLayer.of(List<Geofence> geofences, {Color? color, Key? key})
    : this(
        circles: [
          for (final geofence in geofences)
            (
              center: geofence.center,
              radiusMeters: geofence.radiusMeters,
              label: geofence.name,
            ),
        ],
        color: color,
        key: key,
      );

  final List<GeofenceCircle> circles;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final circleColor = color ?? scheme.tertiary;

    return Stack(
      children: [
        CircleLayer(
          circles: [
            for (final circle in circles)
              CircleMarker(
                point: circle.center,
                radius: circle.radiusMeters,
                useRadiusInMeter: true,
                color: circleColor.withValues(alpha: 0.18),
                borderColor: circleColor,
                borderStrokeWidth: 2,
              ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (final circle in circles)
              Marker(
                point: circle.center,
                width: 140,
                height: 44,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.adjust, size: 18, color: circleColor),
                    if (circle.label case final label? when label.isNotEmpty)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.surface.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
