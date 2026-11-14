import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/status_card.dart';
import 'package:smart_access_security/features/auth/presentation/auth_labels.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/auth_controller.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';

/// Whether biometric unlock is on, and what the device supports.
class BiometricCard extends ConsumerWidget {
  const BiometricCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(biometricStatusProvider);
    final enabled = ref.watch(
      settingsControllerProvider.select((s) => s.biometricsEnabled),
    );
    final value = status.value;

    final (label, tone) = switch (value) {
      null when status.hasError => ('Unknown', StatusTone.warning),
      null => ('', StatusTone.neutral),
      _ when !value.isAvailable => ('Unavailable', StatusTone.warning),
      _ when enabled => ('Enabled', StatusTone.good),
      _ => ('Disabled', StatusTone.neutral),
    };

    return StatusCard(
      icon: Icons.fingerprint,
      title: 'Biometrics',
      value: label,
      detail: value?.summary ?? 'Could not check biometrics',
      tone: tone,
      isLoading: status.isLoading && value == null,
      onTap: () => context.go(Routes.settings),
    );
  }
}

/// When the user last authenticated successfully.
class LastAuthCard extends ConsumerWidget {
  const LastAuthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authStatusProvider);
    final lastAuth = status.value?.lastSuccessfulAuthAt;

    return StatusCard(
      icon: Icons.verified_user_outlined,
      title: 'Last authentication',
      value: status.hasError
          ? 'Unknown'
          : lastAuth == null
          ? 'Never'
          : Formatters.dateTime(lastAuth),
      detail: 'Last successful unlock',
      tone: status.hasError ? StatusTone.warning : StatusTone.good,
      isLoading: status.isLoading && !status.hasValue,
    );
  }
}
