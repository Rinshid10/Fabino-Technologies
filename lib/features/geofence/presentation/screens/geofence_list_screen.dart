import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/app_map.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/state_views.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_list_controller.dart';
import 'package:smart_access_security/features/geofence/presentation/geofence_labels.dart';
import 'package:smart_access_security/features/geofence/presentation/widgets/geofence_actions.dart';
import 'package:smart_access_security/features/geofence/presentation/widgets/geofence_layer.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/location_labels.dart';

/// All geofences: on a map and as a list to edit or delete.
class GeofenceListScreen extends ConsumerWidget {
  const GeofenceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geofences = ref.watch(geofenceListControllerProvider);
    final hasGeofences = geofences.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofences'),
        actions: [
          if (hasGeofences)
            IconButton(
              tooltip: 'Clear geofences',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => confirmClearGeofences(context, ref),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-geofence',
        onPressed: () => context.push(Routes.newGeofence),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add geofence'),
      ),
      body: AsyncValueView(
        value: geofences,
        onRetry: () => ref.invalidate(geofenceListControllerProvider),
        data: (items) => items.isEmpty
            ? EmptyView(
                icon: Icons.radar_outlined,
                title: 'No geofences yet',
                message:
                    'Create a zone on the map and get notified when you '
                    'enter or leave it.',
                actionLabel: 'Add geofence',
                onAction: () => context.push(Routes.newGeofence),
              )
            : _GeofenceOverview(geofences: items),
      ),
    );
  }
}

class _GeofenceOverview extends StatelessWidget {
  const _GeofenceOverview({required this.geofences});

  final List<Geofence> geofences;

  @override
  Widget build(BuildContext context) {
    final map = _GeofenceMap(geofences: geofences);
    final list = ListView.separated(
      // Leave room for the floating button below the last row.
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: geofences.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) =>
          GeofenceListTile(geofence: geofences[index]),
    );

    if (context.isWide) {
      return Row(
        children: [
          Expanded(flex: 3, child: map),
          Expanded(flex: 2, child: list),
        ],
      );
    }
    return Column(
      children: [
        SizedBox(height: 220, child: map),
        Expanded(child: list),
      ],
    );
  }
}

/// Every geofence as a circle, zoomed to show them all.
class _GeofenceMap extends ConsumerWidget {
  const _GeofenceMap({required this.geofences});

  final List<Geofence> geofences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Shows the user's dot only if a position is already known; this
    // screen never asks for location by itself.
    final position = ref.watch(positionStreamServiceProvider).lastFix;
    final centers = [for (final geofence in geofences) geofence.center];

    return AppMap(
      // Rebuild the camera when geofences are added or removed.
      key: ValueKey(geofences.map((g) => g.id).join()),
      initialCenter: centers.first,
      initialZoom: 15,
      initialFit: centers.toSet().length > 1
          ? CameraFit.coordinates(
              coordinates: centers,
              padding: const EdgeInsets.all(56),
              maxZoom: 16,
            )
          : null,
      layers: [
        GeofenceLayer.of(geofences),
        if (position != null)
          PositionLayer(
            point: position.latLng,
            accuracyMeters: position.accuracy,
          ),
      ],
    );
  }
}

/// One geofence row: name, radius, inside / outside state and actions.
class GeofenceListTile extends ConsumerWidget {
  const GeofenceListTile({required this.geofence, super.key});

  final Geofence geofence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isInside = geofence.presence == GeofencePresence.inside;

    return ListTile(
      leading: Icon(
        isInside ? Icons.radio_button_checked : Icons.radar_outlined,
        color: isInside ? scheme.success : null,
      ),
      title: Text(geofence.name),
      subtitle: Text(
        '${Formatters.distance(geofence.radiusMeters)} radius · '
        '${geofence.presence.label}',
      ),
      trailing: IconButton(
        tooltip: 'Delete',
        icon: const Icon(Icons.delete_outline),
        onPressed: () => confirmDeleteGeofence(context, ref, geofence),
      ),
      onTap: () => context.push(Routes.editGeofence(geofence.id)),
    );
  }
}
