import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/errors/failures.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/status_card.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_status_controller.dart';
import 'package:smart_access_security/features/location/presentation/location_labels.dart';

/// Location permission state.
class LocationPermissionCard extends ConsumerWidget {
  const LocationPermissionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(locationStatusControllerProvider);
    final permission = status.value?.permission;

    return StatusCard(
      icon: Icons.location_on_outlined,
      title: 'Location permission',
      value: permission?.label ?? 'Unknown',
      detail: switch (permission) {
        LocationPermissionStatus.denied => 'Tap to allow',
        LocationPermissionStatus.deniedForever => 'Tap to open app settings',
        _ => null,
      },
      tone: switch (permission) {
        null => StatusTone.warning,
        LocationPermissionStatus.denied => StatusTone.bad,
        LocationPermissionStatus.deniedForever => StatusTone.bad,
        _ => StatusTone.good,
      },
      isLoading: status.isLoading && !status.hasValue,
      onTap: switch (permission) {
        LocationPermissionStatus.denied => () => context.push(
          Routes.locationPermission,
        ),
        LocationPermissionStatus.deniedForever =>
          ref.read(locationStatusControllerProvider.notifier).openAppSettings,
        _ => null,
      },
    );
  }
}

/// Whether the device location service is on.
class GpsCard extends ConsumerWidget {
  const GpsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(locationStatusControllerProvider);
    final enabled = status.value?.serviceEnabled;

    return StatusCard(
      icon: enabled ?? false ? Icons.gps_fixed : Icons.gps_off,
      title: 'GPS',
      value: switch (enabled) {
        null => 'Unknown',
        true => 'On',
        false => 'Off',
      },
      detail: enabled ?? true ? null : 'Tap to open location settings',
      tone: switch (enabled) {
        null => StatusTone.warning,
        true => StatusTone.good,
        false => StatusTone.bad,
      },
      isLoading: status.isLoading && !status.hasValue,
      onTap: enabled ?? true
          ? null
          : ref
                .read(locationStatusControllerProvider.notifier)
                .openLocationSettings,
    );
  }
}

/// The current coordinates, when location is usable.
class CurrentLocationCard extends ConsumerWidget {
  const CurrentLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReady =
        ref.watch(locationStatusControllerProvider).value?.isReady ?? false;
    void openMap() => context.go(Routes.map);

    // Do not ask for a position (and trigger errors) while it cannot work.
    if (!isReady) {
      return StatusCard(
        icon: Icons.my_location,
        title: 'Current location',
        value: 'Unavailable',
        detail: 'Needs permission and GPS',
        tone: StatusTone.warning,
        onTap: openMap,
      );
    }

    final location = ref.watch(currentLocationProvider);
    final fix = location.value;
    return StatusCard(
      icon: Icons.my_location,
      title: 'Current location',
      value: fix == null
          ? 'Unavailable'
          : '${Formatters.coordinate(fix.latitude)}, '
                '${Formatters.coordinate(fix.longitude)}',
      detail: fix == null
          ? describeError(location.error ?? '')
          : '${Formatters.accuracy(fix.accuracy)} · '
                '${fix.accuracyLevel.label} accuracy',
      tone: fix == null ? StatusTone.warning : StatusTone.good,
      isLoading: location.isLoading && fix == null,
      onTap: openMap,
    );
  }
}
