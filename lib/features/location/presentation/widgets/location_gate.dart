import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/state_views.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_status_controller.dart';

/// Shows [child] only when location can actually be used.
///
/// Otherwise it explains what is missing and offers the one action that
/// fixes it: ask for permission, open app settings, or switch GPS on.
/// Every screen that needs location wraps its content in this.
class LocationGate extends ConsumerWidget {
  const LocationGate({
    required this.child,
    this.purpose = 'This feature needs your location.',
    super.key,
  });

  final Widget child;

  /// One sentence on why the screen needs location.
  final String purpose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(locationStatusControllerProvider.notifier);

    return AsyncValueView(
      value: ref.watch(locationStatusControllerProvider),
      onRetry: controller.refresh,
      loadingLabel: 'Checking location access…',
      data: (status) => switch (status) {
        LocationStatus(permission: LocationPermissionStatus.denied) =>
          MessageView(
            icon: Icons.location_disabled_outlined,
            title: 'Location permission needed',
            message: purpose,
            actionLabel: 'Continue',
            onAction: () => context.push(Routes.locationPermission),
          ),
        LocationStatus(permission: LocationPermissionStatus.deniedForever) =>
          MessageView(
            icon: Icons.block_outlined,
            title: 'Location permission is blocked',
            message:
                '$purpose Location was permanently denied, so it can only '
                'be allowed from the app settings.',
            actionLabel: 'Open app settings',
            onAction: controller.openAppSettings,
          ),
        LocationStatus(serviceEnabled: false) => MessageView(
          icon: Icons.gps_off_outlined,
          title: 'Location is turned off',
          message: 'Turn on location (GPS) on your device to continue.',
          actionLabel: 'Open location settings',
          onAction: controller.openLocationSettings,
        ),
        _ => child,
      },
    );
  }
}
