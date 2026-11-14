import 'package:flutter/material.dart';

/// A labelled number, such as "Distance 1.24 km".
class StatTile extends StatelessWidget {
  const StatTile({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;

  /// Either a ready string wrapped in [Text] or a live-updating widget.
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        DefaultTextStyle.merge(
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          child: FittedBox(fit: BoxFit.scaleDown, child: value),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
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
      children: [for (final tile in children) Expanded(child: tile)],
    );
  }
}
