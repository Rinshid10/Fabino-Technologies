import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/widgets/status_card.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_list_controller.dart';

/// How many geofences exist and how many the user is inside.
class GeofenceCard extends ConsumerWidget {
  const GeofenceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geofences = ref.watch(geofenceListControllerProvider);
    final items = geofences.value;
    final insideCount =
        items?.where((g) => g.presence == GeofencePresence.inside).length ?? 0;

    return StatusCard(
      icon: Icons.radar_outlined,
      title: 'Geofences',
      value: switch (items?.length) {
        null => 'Unknown',
        0 => 'None',
        1 => '1 geofence',
        final count => '$count geofences',
      },
      detail: switch (items?.length) {
        null => 'Could not load geofences',
        0 => 'Tap to create one',
        _ => 'Inside $insideCount right now',
      },
      tone: items == null ? StatusTone.warning : StatusTone.neutral,
      isLoading: geofences.isLoading && items == null,
      onTap: () => context.go(Routes.geofences),
    );
  }
}
