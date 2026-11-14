import 'package:flutter/material.dart';

/// A row of dots showing how many PIN digits have been entered.
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
              duration: const Duration(milliseconds: 120),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled ? activeColor : Colors.transparent,
                border: Border.all(
                  color: i < filled ? activeColor : scheme.outline,
                  width: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
