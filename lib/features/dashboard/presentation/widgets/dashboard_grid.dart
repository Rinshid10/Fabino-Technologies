import 'package:flutter/material.dart';

/// Lays cards out in as many equal columns as fit the available width.
///
/// One column on very small phones, two on phones, three or more on tablets.
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    required this.children,
    this.minCardWidth = 168,
    this.spacing = 12,
    super.key,
  });

  final List<Widget> children;
  final double minCardWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = ((width + spacing) / (minCardWidth + spacing))
            .floor()
            .clamp(1, 4);
        final cardWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: cardWidth, child: child),
          ],
        );
      },
    );
  }
}
