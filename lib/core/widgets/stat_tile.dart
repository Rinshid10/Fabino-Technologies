import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/pills.dart';

/// A labelled number, such as "Distance 1.24 km".
class StatTile extends StatelessWidget {
  const StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isAccent = false,
    super.key,
  });

  final IconData icon;
  final String label;

  /// Either a ready string wrapped in [Text] or a live-updating widget.
  final Widget value;

  /// Draws the value in the primary colour.
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: isAccent ? scheme.primaryDeep : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Flexible(child: CapsLabel(label)),
          ],
        ),
        const SizedBox(height: 4),
        DefaultTextStyle.merge(
          style: theme.textTheme.titleLarge?.copyWith(
            color: isAccent ? scheme.primaryDeep : null,
            fontSize: 22,
            height: 27 / 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.55,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: value,
          ),
        ),
      ],
    );
  }
}

/// A row of equally wide [StatTile]s.
class StatRow extends StatelessWidget {
  const StatRow({required this.children, super.key});

  final List<StatTile> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, tile) in children.indexed) ...[
          if (index > 0) const SizedBox(width: 12),
          Expanded(child: tile),
        ],
      ],
    );
  }
}

/// A number with its unit in small grey letters, such as "8.42 km".
///
/// [text] is split at its last space; without one it is shown as is.
class StatValue extends StatelessWidget {
  const StatValue(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final split = text.lastIndexOf(' ');
    if (split < 0) return Text(text);

    return Text.rich(
      TextSpan(
        text: text.substring(0, split),
        children: [
          TextSpan(
            text: text.substring(split),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.24,
            ),
          ),
        ],
      ),
    );
  }
}
