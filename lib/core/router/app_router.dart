import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/router/app_shell.dart';
import 'package:smart_access_security/core/router/lock_redirect.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';
import 'package:smart_access_security/features/auth/presentation/screens/change_pin_screen.dart';
import 'package:smart_access_security/features/auth/presentation/screens/lock_screen.dart';
import 'package:smart_access_security/features/auth/presentation/screens/pin_setup_screen.dart';
import 'package:smart_access_security/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:smart_access_security/features/location/presentation/screens/location_permission_screen.dart';
import 'package:smart_access_security/features/location/presentation/screens/map_screen.dart';
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
    label: 'Map',
    icon: Icons.map_outlined,
    selectedIcon: Icons.map,
  ),
  ShellDestination(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Re-runs the redirect guard whenever the lock state changes.
  final lockState = ValueNotifier(ref.read(appLockProvider));
  ref.listen(appLockProvider, (_, next) => lockState.value = next);

  final router = GoRouter(
    initialLocation: Routes.dashboard,
    refreshListenable: lockState,
    redirect: (context, state) => resolveLockRedirect(
      lockState: ref.read(appLockProvider),
      location: state.uri,
    ),
    routes: [
      GoRoute(
        path: Routes.setupPin,
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: Routes.lock,
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: Routes.locationPermission,
        builder: (context, state) => const LocationPermissionScreen(),
      ),
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
                path: Routes.map,
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'change-pin',
                    builder: (context, state) => const ChangePinScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    lockState.dispose();
  });
  return router;
}
