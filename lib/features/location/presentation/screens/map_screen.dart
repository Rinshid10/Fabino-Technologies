import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/widgets/app_map.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/location_labels.dart';
import 'package:smart_access_security/features/location/presentation/widgets/location_details_card.dart';
import 'package:smart_access_security/features/location/presentation/widgets/location_gate.dart';
import 'package:smart_access_security/features/location/presentation/widgets/mock_location_banner.dart';

/// Current position on the map with its coordinates, accuracy and address.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: const LocationGate(
        purpose: 'The map needs your location to show where you are.',
        child: _CurrentLocationView(),
      ),
    );
  }
}

class _CurrentLocationView extends ConsumerStatefulWidget {
  const _CurrentLocationView();

  @override
  ConsumerState<_CurrentLocationView> createState() =>
      _CurrentLocationViewState();
}

class _CurrentLocationViewState extends ConsumerState<_CurrentLocationView> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Gets a fresh fix, then centres the map on it.
  Future<void> _refreshAndRecenter() async {
    try {
      await ref.read(currentLocationProvider.notifier).refresh();
    } on Exception {
      // The error state is rendered by AsyncValueView below.
      return;
    }
    final fix = ref.read(currentLocationProvider).value;
    if (fix != null && mounted) {
      _mapController.move(fix.latLng, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(currentLocationProvider);

    return AsyncValueView(
      value: location,
      onRetry: () => ref.invalidate(currentLocationProvider),
      loadingLabel: 'Finding your location…',
      data: (fix) {
        final map = _LocationMap(
          fix: fix,
          controller: _mapController,
          isRefreshing: location.isLoading,
          onRefresh: _refreshAndRecenter,
        );
        final details = Padding(
          padding: const EdgeInsets.all(12),
          child: LocationDetailsCard(fix: fix),
        );

        return Column(
          children: [
            if (fix.isMocked) const MockLocationBanner(),
            Expanded(
              child: context.isWide
                  ? Row(
                      children: [
                        Expanded(child: map),
                        SizedBox(
                          width: 340,
                          child: SingleChildScrollView(child: details),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: map),
                        details,
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _LocationMap extends StatelessWidget {
  const _LocationMap({
    required this.fix,
    required this.controller,
    required this.isRefreshing,
    required this.onRefresh,
  });

  final LocationFix fix;
  final MapController controller;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppMap(
          controller: controller,
          initialCenter: fix.latLng,
          layers: [
            PositionLayer(point: fix.latLng, accuracyMeters: fix.accuracy),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 28,
          child: FloatingActionButton(
            heroTag: 'map-recenter',
            tooltip: 'Refresh and recenter',
            onPressed: isRefreshing ? null : onRefresh,
            child: isRefreshing
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
