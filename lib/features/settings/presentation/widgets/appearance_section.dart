import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Appearance'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<AppThemeMode>(
              segments: [
                for (final mode in AppThemeMode.values)
                  ButtonSegment(
                    value: mode,
                    icon: Icon(mode.icon),
                    label: Text(mode.label),
                  ),
              ],
              selected: {themeMode},
              onSelectionChanged: (selection) => ref
                  .read(settingsControllerProvider.notifier)
                  .setThemeMode(selection.first),
            ),
          ),
        ),
      ],
    );
  }
}
