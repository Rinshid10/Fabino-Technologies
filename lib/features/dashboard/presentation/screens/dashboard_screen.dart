import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/widgets/brand_title.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
import 'package:smart_access_security/core/widgets/status_card.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/auth_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/geofence_card.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/location_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/security_overview_card.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/tracking_card.dart';

/// Home screen: an overall summary, then the security status grouped into
/// access, location and activity, and two quick actions.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _gutter = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: BrandTitle.toolbarHeight,
        title: const BrandTitle('Dashboard'),
      ),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 28),
          children: const [
            Padding(padding: _gutter, child: SecurityOverviewCard()),
            _StatusGroup(
              title: 'Access',
              children: [BiometricCard(), LastAuthCard()],
            ),
            _StatusGroup(
              title: 'Location',
              children: [
                LocationPermissionCard(),
                GpsCard(),
                CurrentLocationCard(),
              ],
            ),
            SectionHeader('Activity'),
            Padding(
              padding: _gutter,
              // Both tiles take the height of the taller one.
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: TrackingCard()),
                    SizedBox(width: 8),
                    Expanded(child: GeofenceCard()),
                  ],
                ),
              ),
            ),
            SectionHeader('Quick actions'),
            Padding(padding: _gutter, child: _QuickActions()),
          ],
        ),
      ),
    );
  }
}

/// A titled panel whose status cards are shown as rows with dividers.
class _StatusGroup extends StatelessWidget {
  const _StatusGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return StatusCardTheme(
      layout: StatusCardLayout.row,
      child: SectionCard(
        title: title,
        children: [
          for (final (index, child) in children.indexed) ...[
            if (index > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            child,
          ],
        ],
      ),
    );
  }
}

/// Shortcuts to the tracking history and to locking the app.
class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push(Routes.trackingHistory),
            icon: const Icon(Icons.history),
            label: const Text('History'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            onPressed: ref.read(appLockProvider.notifier).lock,
            icon: const Icon(Icons.lock_outline),
            label: const Text('Lock app now'),
          ),
        ),
      ],
    );
  }
}
