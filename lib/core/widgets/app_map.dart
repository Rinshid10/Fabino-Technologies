import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// The app's map: OpenStreetMap tiles plus whatever [layers] a screen adds.
///
/// Every screen uses this instead of `FlutterMap` directly so tile source,
/// attribution and zoom limits are defined once.
class AppMap extends StatelessWidget {
  const AppMap({
    required this.initialCenter,
    this.initialZoom = 16,
    this.initialFit,
    this.controller,
    this.layers = const [],
    this.onTap,
    this.onLongPress,
    this.interactive = true,
    super.key,
  });

  final LatLng initialCenter;
  final double initialZoom;

  /// When set, the map starts zoomed to show these bounds instead.
  final CameraFit? initialFit;
  final MapController? controller;
  final List<Widget> layers;
  final ValueChanged<LatLng>? onTap;
  final ValueChanged<LatLng>? onLongPress;
  final bool interactive;

  static const _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const _userAgent = 'com.example.smart_access_security';

  @override
  Widget build(BuildContext context) {
    final onTap = this.onTap;
    final onLongPress = this.onLongPress;

    final map = FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        initialCameraFit: initialFit,
        minZoom: 3,
        maxZoom: 19,
        interactionOptions: InteractionOptions(
          flags: interactive
              ? InteractiveFlag.all & ~InteractiveFlag.rotate
              : InteractiveFlag.none,
        ),
        onTap: onTap == null ? null : (_, point) => onTap(point),
        onLongPress: onLongPress == null
            ? null
            : (_, point) => onLongPress(point),
      ),
      children: [
        TileLayer(
          urlTemplate: _tileUrl,
          userAgentPackageName: _userAgent,
        ),
        ...layers,
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );

    // The map sits in a raised frame with rounded corners.
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SoftSurface(
        radius: 26,
        padding: const EdgeInsets.all(5),
        child: ClipRRect(borderRadius: BorderRadius.circular(21), child: map),
      ),
    );
  }
}

/// A dot for the user's position with a translucent accuracy circle.
class PositionLayer extends StatelessWidget {
  const PositionLayer({
    required this.point,
    this.accuracyMeters,
    super.key,
  });

  final LatLng point;
  final double? accuracyMeters;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final accuracy = accuracyMeters;

    return Stack(
      children: [
        if (accuracy != null && accuracy > 0)
          CircleLayer(
            circles: [
              CircleMarker(
                point: point,
                radius: accuracy,
                useRadiusInMeter: true,
                color: color.withValues(alpha: 0.15),
                borderColor: color.withValues(alpha: 0.4),
                borderStrokeWidth: 1,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              point: point,
              width: 22,
              height: 22,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(blurRadius: 4, color: Colors.black38),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// One or more routes drawn as lines.
class RouteLayer extends StatelessWidget {
  const RouteLayer({
    required this.routes,
    this.color,
    this.strokeWidth = 5,
    super.key,
  });

  /// Each inner list is one continuous route.
  final List<List<LatLng>> routes;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final lineColor = color ?? Theme.of(context).colorScheme.primary;
    return PolylineLayer(
      polylines: [
        for (final points in routes)
          // A line needs at least two points.
          if (points.length > 1)
            Polyline(
              points: points,
              color: lineColor,
              strokeWidth: strokeWidth,
            ),
      ],
    );
  }
}

/// A small pin with an icon, for route start / end points.
class PinLayer extends StatelessWidget {
  const PinLayer({required this.pins, super.key});

  final List<({LatLng point, IconData icon, Color color})> pins;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        for (final pin in pins)
          Marker(
            point: pin.point,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: pin.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(pin.icon, size: 16, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
