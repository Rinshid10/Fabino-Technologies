import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
import 'package:smart_access_security/core/widgets/status_card.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/auth_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/geofence_card.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/location_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/security_overview_card.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/tracking_card.dart';

/// Home screen: an overall summary, then the security status grouped into
/// access, location and activity.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _gutter = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security dashboard')),
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
                    SizedBox(width: 14),
                    Expanded(child: GeofenceCard()),
                  ],
                ),
              ),
            ),
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
            // Aligned with the text, not the icon.
            if (index > 0) const Divider(height: 1, indent: 72, endIndent: 16),
            child,
          ],
        ],
      ),
    );
  }
}
