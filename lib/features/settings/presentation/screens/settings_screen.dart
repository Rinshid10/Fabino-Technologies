import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/brand_title.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/features/settings/presentation/widgets/appearance_section.dart';
import 'package:smart_access_security/features/settings/presentation/widgets/data_section.dart';
import 'package:smart_access_security/features/settings/presentation/widgets/security_section.dart';

/// App preferences, grouped into sections.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: BrandTitle.toolbarHeight,
        title: const BrandTitle('Settings'),
      ),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: const [
            AppearanceSection(),
            SecuritySection(),
            DataSection(),
            _MapCredit(),
          ],
        ),
      ),
    );
  }
}

/// Credit for the map data, required by the OpenStreetMap licence.
class _MapCredit extends StatelessWidget {
  const _MapCredit();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Text(
        'Map data © OpenStreetMap contributors',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
