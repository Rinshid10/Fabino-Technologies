import 'package:flutter/material.dart';

/// A row of small circles that fill smoothly as digits are entered.
class PinDots extends StatelessWidget {
  const PinDots({
    required this.length,
    required this.filled,
    this.hasError = false,
    super.key,
  });

  final int length;
  final int filled;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeColor = hasError ? scheme.error : scheme.primary;

    return Semantics(
      label: '$filled of $length digits entered',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < length; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled
                    ? activeColor
                    : scheme.onSurface.withValues(alpha: 0.12),
              ),
            ),
        ],
      ),
    );
  }
}
