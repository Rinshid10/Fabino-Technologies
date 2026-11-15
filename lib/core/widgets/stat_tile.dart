import 'package:flutter/material.dart';
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
              size: 15,
              color: isAccent ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Flexible(child: CapsLabel(label)),
          ],
        ),
        const SizedBox(height: 4),
        DefaultTextStyle.merge(
          style: theme.textTheme.titleLarge?.copyWith(
            color: isAccent ? scheme.primary : null,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
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
