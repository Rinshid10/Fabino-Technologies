import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
import 'package:smart_access_security/features/auth/presentation/auth_labels.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/auth_controller.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';
import 'package:smart_access_security/features/settings/presentation/settings_labels.dart';

/// Biometric toggle, auto-lock duration, screenshot protection and
/// change PIN.
class SecuritySection extends ConsumerWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return SectionCard(
      title: 'Security',
      children: [
        const _BiometricTile(),
        ListTile(
          leading: const Icon(Icons.timer_outlined),
          title: const Text('Auto-lock'),
          subtitle: Text(settings.autoLockDuration.label),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _pickAutoLock(context, ref, settings.autoLockDuration),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.screenshot_monitor_outlined),
          title: const Text('Screenshot protection'),
          subtitle: const Text(
            'Block screenshots, screen recording and the app preview.',
          ),
          value: settings.screenshotProtection,
          onChanged: (value) => ref
              .read(settingsControllerProvider.notifier)
              .setScreenshotProtection(enabled: value),
        ),
        ListTile(
          leading: const Icon(Icons.password_outlined),
          title: const Text('Change PIN'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(Routes.changePin),
        ),
      ],
    );
  }

  Future<void> _pickAutoLock(
    BuildContext context,
    WidgetRef ref,
    AutoLockDuration current,
  ) async {
    final picked = await showDialog<AutoLockDuration>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Lock the app'),
        children: [
          RadioGroup<AutoLockDuration>(
            groupValue: current,
            onChanged: (value) => Navigator.of(context).pop(value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in AutoLockDuration.values)
                  RadioListTile(value: option, title: Text(option.label)),
              ],
            ),
          ),
        ],
      ),
    );
    if (picked == null) return;
    await ref
        .read(settingsControllerProvider.notifier)
        .setAutoLockDuration(picked);
  }
}

/// Switch for biometric unlock. Turning it on requires a successful
/// biometric check, so it cannot be enabled for someone else's finger.
class _BiometricTile extends ConsumerWidget {
  const _BiometricTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      settingsControllerProvider.select((s) => s.biometricsEnabled),
    );
    final status = ref.watch(biometricStatusProvider);
    final isAvailable = status.value?.isAvailable ?? false;

    return SwitchListTile(
      secondary: const Icon(Icons.fingerprint),
      title: const Text('Biometric unlock'),
      subtitle: Text(
        status.when(
          data: (value) => value.summary,
          loading: () => 'Checking this device…',
          error: (_, _) => 'Could not check biometrics',
        ),
      ),
      value: enabled && isAvailable,
      onChanged: isAvailable
          ? (value) => _toggle(context, ref, enable: value)
          : null,
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref, {
    required bool enable,
  }) async {
    final settings = ref.read(settingsControllerProvider.notifier);
    if (!enable) return settings.setBiometricsEnabled(enabled: false);

    final result = await ref
        .read(authControllerProvider)
        .authenticateWithBiometrics(reason: 'Confirm to enable biometrics');
    if (result.isSuccess) {
      return settings.setBiometricsEnabled(enabled: true);
    }

    final message = result.message;
    if (message != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
