import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/widgets/app_map.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/location_labels.dart';
import 'package:smart_access_security/features/location/presentation/widgets/location_gate.dart';
import 'package:smart_access_security/features/location/presentation/widgets/mock_location_banner.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/tracking_labels.dart';
import 'package:smart_access_security/features/tracking/presentation/widgets/session_stats.dart';

/// Start / stop a tracking session and watch the route grow on the map.
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking'),
        actions: [
          IconButton(
            tooltip: 'History',
            icon: const Icon(Icons.history),
            onPressed: () => context.push(Routes.trackingHistory),
          ),
        ],
      ),
      body: const LocationGate(
        purpose: 'Tracking needs your location to record your route.',
        child: _TrackingView(),
      ),
    );
  }
}

class _TrackingView extends ConsumerStatefulWidget {
  const _TrackingView();

  @override
  ConsumerState<_TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends ConsumerState<_TrackingView> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _stop() async {
    final session = await ref.read(trackingControllerProvider.notifier).stop();
    if (session == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Session saved.'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => context.push(Routes.sessionDetail(session.id)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tracking = ref.watch(trackingControllerProvider);
    final session = tracking.session;

    // Keep the camera on the user while a session is running.
    ref.listen(trackingControllerProvider.select((s) => s.lastFix), (_, fix) {
      if (fix != null) {
        _mapController.move(fix.latLng, _mapController.camera.zoom);
      }
    });

    return AsyncValueView(
      value: ref.watch(currentLocationProvider),
      onRetry: () => ref.invalidate(currentLocationProvider),
      loadingLabel: 'Finding your location…',
      data: (current) {
        final position = tracking.lastFix ?? current;
        final map = AppMap(
          controller: _mapController,
          initialCenter: position.latLng,
          initialZoom: 17,
          layers: [
            if (session != null) RouteLayer(routes: [session.route]),
            PositionLayer(
              point: position.latLng,
              accuracyMeters: position.accuracy,
            ),
          ],
        );
        final panel = _ControlPanel(
          tracking: tracking,
          onStart: ref.read(trackingControllerProvider.notifier).start,
          onStop: _stop,
        );

        return Column(
          children: [
            if (session?.hadMockedLocation ?? position.isMocked)
              const MockLocationBanner(),
            Expanded(
              child: context.isWide
                  ? Row(
                      children: [
                        Expanded(child: map),
                        SizedBox(width: 340, child: panel),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: map),
                        panel,
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// Live numbers and the start / stop button.
class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.tracking,
    required this.onStart,
    required this.onStop,
  });

  final TrackingState tracking;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final session = tracking.session;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SoftSurface(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (session != null) ...[
                SessionStats(
                  session: session,
                  liveSpeed: tracking.currentSpeed,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  ),
                  onPressed: onStop,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop tracking'),
                ),
              ] else ...[
                Text(
                  'Record your route, distance and speed. Tracking keeps '
                  'running when the app is locked or minimised.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: tracking.isStarting ? null : onStart,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(
                    tracking.isStarting ? 'Starting…' : 'Start tracking',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
