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
          ],
        ),
      ),
    );
  }
}
