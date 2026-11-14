import 'package:flutter/material.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';

/// Display text and Flutter mappings for [AppThemeMode].
extension AppThemeModeX on AppThemeMode {
  String get label => switch (this) {
    AppThemeMode.system => 'System',
    AppThemeMode.light => 'Light',
    AppThemeMode.dark => 'Dark',
  };

  IconData get icon => switch (this) {
    AppThemeMode.system => Icons.brightness_auto_outlined,
    AppThemeMode.light => Icons.light_mode_outlined,
    AppThemeMode.dark => Icons.dark_mode_outlined,
  };

  ThemeMode get themeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}

/// Display text for [AutoLockDuration].
extension AutoLockDurationX on AutoLockDuration {
  String get label => switch (this) {
    AutoLockDuration.immediately => 'Immediately',
    AutoLockDuration.seconds30 => 'After 30 seconds',
    AutoLockDuration.minute1 => 'After 1 minute',
    AutoLockDuration.minutes5 => 'After 5 minutes',
    AutoLockDuration.never => 'Never',
  };
}
