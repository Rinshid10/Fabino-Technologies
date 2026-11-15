import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// Small uppercase heading used to group items in lists and settings.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;

  /// Shown at the end of the line, for example a status.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A card that holds list rows or other content.
///
/// The transparent [Material] lets ink splashes of `ListTile`s show on
/// top of the panel.
class SoftPanel extends StatelessWidget {
  const SoftPanel({
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
    this.padding = const EdgeInsets.symmetric(vertical: 6),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: SoftSurface(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Material(
            type: MaterialType.transparency,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// A titled group of rows inside one card, as used in settings.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.children,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(title, trailing: trailing),
        SoftPanel(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ],
    );
  }
}
