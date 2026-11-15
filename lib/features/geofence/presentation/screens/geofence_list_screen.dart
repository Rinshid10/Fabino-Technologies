import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/app_map.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/brand_title.dart';
import 'package:smart_access_security/core/widgets/pills.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';
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
        toolbarHeight: BrandTitle.toolbarHeight,
        title: const BrandTitle('Geofences'),
        actions: [
          if (hasGeofences) ...[
            RoundIconButton(
              tooltip: 'Clear geofences',
              icon: Icons.delete_sweep_outlined,
              onPressed: () => confirmClearGeofences(context, ref),
            ),
            const SizedBox(width: 20),
          ],
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

enum _Filter { all, inside, outside }

class _GeofenceOverview extends StatefulWidget {
  const _GeofenceOverview({required this.geofences});

  final List<Geofence> geofences;

  @override
  State<_GeofenceOverview> createState() => _GeofenceOverviewState();
}

class _GeofenceOverviewState extends State<_GeofenceOverview> {
  _Filter _filter = _Filter.all;

  List<Geofence> _matching(_Filter filter) {
    return switch (filter) {
      _Filter.all => widget.geofences,
      _Filter.inside => [
        for (final geofence in widget.geofences)
          if (geofence.presence == GeofencePresence.inside) geofence,
      ],
      _Filter.outside => [
        for (final geofence in widget.geofences)
          if (geofence.presence != GeofencePresence.inside) geofence,
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final visible = _matching(_filter);
    final map = _GeofenceMap(geofences: widget.geofences);
    final list = ListView.builder(
      // Leave room for the floating button below the last card.
      padding: const EdgeInsets.only(top: 4, bottom: 104),
      // The filter comes before the cards.
      itemCount: visible.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: _FilterBar(
              selected: _filter,
              counts: {
                for (final filter in _Filter.values)
                  filter: _matching(filter).length,
              },
              onSelected: (filter) => setState(() => _filter = filter),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: GeofenceListTile(geofence: visible[index - 1]),
        );
      },
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
        SizedBox(height: 210, child: map),
        Expanded(child: list),
      ],
    );
  }
}

/// All / Inside / Outside, each with its number of geofences.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  final _Filter selected;
  final Map<_Filter, int> counts;
  final ValueChanged<_Filter> onSelected;

  static String _nameOf(_Filter filter) => switch (filter) {
    _Filter.all => 'All',
    _Filter.inside => 'Inside',
    _Filter.outside => 'Outside',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InsetPanel(
      padding: const EdgeInsets.all(4),
      radius: 26,
      child: Row(
        children: [
          for (final filter in _Filter.values)
            Expanded(
              child: Semantics(
                button: true,
                selected: filter == selected,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: filter == selected
                          ? scheme.primary
                          : Colors.transparent,
                    ),
                    child: Text(
                      '${_nameOf(filter)} (${counts[filter] ?? 0})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: filter == selected
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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

/// One geofence card: name, inside / outside state, radius and actions.
class GeofenceListTile extends ConsumerWidget {
  const GeofenceListTile({required this.geofence, super.key});

  final Geofence geofence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isInside = geofence.presence == GeofencePresence.inside;
    void edit() => context.push(Routes.editGeofence(geofence.id));

    return SoftPressable(
      onTap: edit,
      semanticLabel: geofence.name,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SoftIconWell(
                icon: isInside
                    ? Icons.where_to_vote_outlined
                    : Icons.radar_outlined,
                color: isInside ? scheme.success : null,
                size: 46,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  geofence.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(
                label: geofence.presence.label,
                color: isInside ? scheme.success : scheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 14),
          InsetPanel(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _Detail(
                    icon: Icons.radio_button_unchecked,
                    label: 'Radius',
                    value: Formatters.distance(geofence.radiusMeters),
                  ),
                ),
                const Expanded(
                  child: _Detail(
                    icon: Icons.notifications_active_outlined,
                    label: 'Alerts',
                    value: 'Entry & exit',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              RoundIconButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit',
                isFlat: true,
                size: 42,
                onPressed: edit,
              ),
              const SizedBox(width: 8),
              RoundIconButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete',
                isFlat: true,
                size: 42,
                color: scheme.error,
                onPressed: () => confirmDeleteGeofence(context, ref, geofence),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
