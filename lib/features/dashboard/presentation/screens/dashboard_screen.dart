import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/pastel_background.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/auth_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/dashboard_grid.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/geofence_card.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/location_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/tracking_card.dart';

/// Home screen: a header with the shield badge and a grid of status
/// cards on a pastel background.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PastelBackground(
        child: SafeArea(
          bottom: false,
          child: ContentWidth(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  DashboardHeader(),
                  SizedBox(height: 20),
                  DashboardGrid(
                    children: [
                      BiometricCard(),
                      LastAuthCard(),
                      LocationPermissionCard(),
                      GpsCard(),
                      CurrentLocationCard(),
                      TrackingCard(),
                      GeofenceCard(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
