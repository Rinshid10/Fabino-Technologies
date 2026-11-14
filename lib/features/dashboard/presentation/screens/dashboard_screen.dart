import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/auth_cards.dart';
import 'package:smart_access_security/features/dashboard/presentation/widgets/dashboard_grid.dart';

/// Home screen: a grid of security status cards.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security dashboard')),
      body: const ContentWidth(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: DashboardGrid(
            children: [BiometricCard(), LastAuthCard()],
          ),
        ),
      ),
    );
  }
}
