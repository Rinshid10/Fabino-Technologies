import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.alphaBlend(
              scheme.tertiary.withValues(alpha: 0.55),
              scheme.primary,
            ),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.28),
            offset: const Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: scheme.onPrimary),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAllSet ? 'You are all set' : 'Finish setting up',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAllSet
                        ? 'App lock, location and GPS are ready.'
                        : 'Still off: ${openItems.join(', ')}.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(
                        icon: Icons.lock_clock_outlined,
                        label: lastAuth == null
                            ? 'Not unlocked yet'
                            : 'Unlocked ${Formatters.dateTime(lastAuth)}',
                      ),
                      if (isTracking)
                        const _Pill(
                          icon: Icons.route_outlined,
                          label: 'Tracking in progress',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              isAllSet ? Icons.verified_user : Icons.shield_outlined,
              size: 56,
              color: scheme.onPrimary.withValues(alpha: 0.9),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small translucent label on the overview card.
class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: onPrimary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: onPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
