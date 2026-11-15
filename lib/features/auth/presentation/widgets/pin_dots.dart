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
              margin: const EdgeInsets.symmetric(horizontal: 7),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled
                    ? activeColor
                    : scheme.primary.withValues(alpha: 0.2),
              ),
            ),
        ],
      ),
    );
  }
}
