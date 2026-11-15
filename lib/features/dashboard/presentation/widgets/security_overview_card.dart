import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/pills.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/auth_controller.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_status_controller.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_controller.dart';

/// The headline of the dashboard: is everything set up, or does something
/// need attention?
class SecurityOverviewCard extends ConsumerWidget {
  const SecurityOverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final location = ref.watch(locationStatusControllerProvider).value;
    final biometricsReady =
        ref.watch(settingsControllerProvider).biometricsEnabled &&
        (ref.watch(biometricStatusProvider).value?.isAvailable ?? false);
    final lastAuth = ref.watch(authStatusProvider).value?.lastSuccessfulAuthAt;
    final isTracking = ref.watch(
      trackingControllerProvider.select((state) => state.isTracking),
    );

    // Each entry is one thing the user could still switch on.
    final openItems = [
      if (!biometricsReady) 'biometric unlock',
      if (!(location?.permission.isGranted ?? false)) 'location permission',
      if (!(location?.serviceEnabled ?? false)) 'GPS',
    ];
    final isAllSet = openItems.isEmpty;
    final tone = isAllSet ? scheme.success : scheme.warning;

    return SoftSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: StatusPill(
                    label: isAllSet ? 'All systems secure' : 'Needs attention',
                    color: tone,
                  ),
                ),
              ),
              SoftIconWell(
                icon: isAllSet
                    ? Icons.verified_user_outlined
                    : Icons.shield_outlined,
                color: tone,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isAllSet ? 'You are all set' : 'Finish setting up',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isAllSet
                ? 'App lock, location and GPS are ready.'
                : 'Still off: ${openItems.join(', ')}.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          InsetPanel(
            child: Row(
              children: [
                Icon(
                  isTracking ? Icons.route_outlined : Icons.lock_clock_outlined,
                  size: 17,
                  color: scheme.primaryDeep,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isTracking
                        ? 'Tracking in progress'
                        : lastAuth == null
                        ? 'Not unlocked yet'
                        : 'Unlocked ${Formatters.dateTime(lastAuth)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.24,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const StatusPill(
                  label: 'Offline',
                  icon: Icons.cloud_off_outlined,
                  uppercase: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
