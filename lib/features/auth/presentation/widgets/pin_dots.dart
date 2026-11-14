import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// A row of small wells that fill with a glowing dot as digits are
/// entered.
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: SizedBox.square(
                dimension: 18,
                child: SoftSurface(
                  isCircle: true,
                  isPressed: true,
                  child: AnimatedScale(
                    scale: i < filled ? 1 : 0,
                    duration: const Duration(milliseconds: 120),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor,
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
