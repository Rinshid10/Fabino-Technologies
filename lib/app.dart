import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/router/app_router.dart';
import 'package:smart_access_security/core/security/screen_protection.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/auto_lock_controller.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_monitor.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';
import 'package:smart_access_security/features/settings/presentation/settings_labels.dart';

/// Root widget: wires the router, the theme and app-wide services.
class SmartAccessApp extends ConsumerWidget {
  const SmartAccessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      settingsControllerProvider.select((settings) => settings.themeMode),
    );
    // Watching keeps the auto-lock service alive for the app's lifetime.
    final autoLock = ref.watch(autoLockProvider);
    // Geofence entry / exit detection runs for the app's whole lifetime.
    ref
      ..watch(geofenceMonitorProvider)
      // Applies the screenshot-protection setting to the platform.
      ..watch(screenProtectionProvider);

    return MaterialApp.router(
      title: 'Smart Access & Location Security',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode.themeMode,
      routerConfig: ref.watch(appRouterProvider),
      // Every touch anywhere in the app resets the inactivity countdown.
      builder: (context, child) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => autoLock.onUserActivity(),
        child: child,
      ),
    );
  }
}
