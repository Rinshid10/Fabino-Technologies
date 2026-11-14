import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/router/app_shell.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:smart_access_security/features/settings/presentation/screens/settings_screen.dart';

part 'app_router.g.dart';

/// Tabs of the main shell. The order must match the branches below.
const _destinations = [
  ShellDestination(
    label: 'Dashboard',
    icon: Icons.shield_outlined,
    selectedIcon: Icons.shield,
  ),
  ShellDestination(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: Routes.dashboard,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(
          navigationShell: navigationShell,
          destinations: _destinations,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
