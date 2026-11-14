import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
import 'package:smart_access_security/core/widgets/soft_segmented.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';
import 'package:smart_access_security/features/settings/presentation/settings_labels.dart';

/// Light / dark / system theme selector.
class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      settingsControllerProvider.select((settings) => settings.themeMode),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader('Appearance'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SoftSegmented<AppThemeMode>(
            segments: [
              for (final mode in AppThemeMode.values)
                (value: mode, icon: mode.icon, label: mode.label),
            ],
            selected: themeMode,
            onSelected: ref
                .read(settingsControllerProvider.notifier)
                .setThemeMode,
          ),
        ),
      ],
    );
  }
}
