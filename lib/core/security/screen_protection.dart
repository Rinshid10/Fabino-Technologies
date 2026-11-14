import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';

part 'screen_protection.g.dart';

/// Blocks screenshots, screen recording and the app-switcher preview.
// An interface keeps the plugin swappable and the setting testable.
// ignore: one_member_abstracts
abstract interface class ScreenProtector {
  Future<void> setProtected({required bool protected});
}

/// [ScreenProtector] backed by `no_screenshot` (FLAG_SECURE on Android, a
/// secure overlay on iOS).
class NoScreenshotProtector implements ScreenProtector {
  const NoScreenshotProtector();

  @override
  Future<void> setProtected({required bool protected}) async {
    try {
      final plugin = NoScreenshot.instance;
      await (protected ? plugin.screenshotOff() : plugin.screenshotOn());
    } on Exception {
      // Not supported on this platform: the setting simply has no effect.
    }
  }
}

@Riverpod(keepAlive: true)
ScreenProtector screenProtector(Ref ref) => const NoScreenshotProtector();

/// Keeps the platform protection in sync with the user's setting.
///
/// Protection covers the whole app, which includes the lock screen, the
/// PIN screens and the dashboard. The root widget watches this provider
/// once.
@Riverpod(keepAlive: true)
void screenProtection(Ref ref) {
  final protector = ref.watch(screenProtectorProvider);
  ref.listen(
    settingsControllerProvider.select((s) => s.screenshotProtection),
    (_, enabled) => unawaited(protector.setProtected(protected: enabled)),
    fireImmediately: true,
  );
}
