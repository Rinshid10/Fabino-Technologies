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

  static const _size = 14.0;
  static const _emptyLight = Color(0xFFD3E4FE);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeColor = hasError ? scheme.error : scheme.primary;
    final emptyColor = scheme.brightness == Brightness.light
        ? _emptyLight
        : scheme.onSurface.withValues(alpha: 0.16);

    return Semantics(
      label: '$filled of $length digits entered',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _size / 2),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                scale: i < filled ? 1.1 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < filled ? activeColor : emptyColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
