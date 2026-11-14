import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/router/app_router.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';
import 'package:smart_access_security/features/settings/presentation/settings_labels.dart';

/// Root widget: wires the router and the theme.
class SmartAccessApp extends ConsumerWidget {
  const SmartAccessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      settingsControllerProvider.select((settings) => settings.themeMode),
    );

    return MaterialApp.router(
      title: 'Smart Access & Location Security',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode.themeMode,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
