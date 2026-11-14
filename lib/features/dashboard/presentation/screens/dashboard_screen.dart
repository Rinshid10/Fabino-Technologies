import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/auth_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/dashboard_grid.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/geofence_card.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/location_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/tracking_card.dart';

/// Home screen: a grid of security status cards.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security dashboard')),
      body: const ContentWidth(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: DashboardGrid(
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
        ),
      ),
    );
  }
}
