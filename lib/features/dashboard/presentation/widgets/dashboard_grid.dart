import 'package:flutter/material.dart';

/// Lays cards out in equal columns; the cards of one row share the height
/// of the tallest one.
///
/// Two columns on phones (one on very narrow screens), more on tablets.
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    required this.children,
    this.minCardWidth = 150,
    this.spacing = 16,
    super.key,
  });

  final List<Widget> children;
  final double minCardWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            ((constraints.maxWidth + spacing) / (minCardWidth + spacing))
                .floor()
                .clamp(1, 4);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var start = 0; start < children.length; start += columns) ...[
              if (start > 0) SizedBox(height: spacing),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var column = 0; column < columns; column++) ...[
                      if (column > 0) SizedBox(width: spacing),
                      Expanded(
                        // An empty cell keeps the last row's cards the
                        // same width as the others.
                        child: start + column < children.length
                            ? children[start + column]
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
