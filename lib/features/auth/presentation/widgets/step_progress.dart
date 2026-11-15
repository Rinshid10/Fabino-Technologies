import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/pills.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// A card that shows how far a multi-step flow is: "STEP 2 OF 3", a
/// segmented bar and the name of every step.
class StepProgress extends StatelessWidget {
  const StepProgress({required this.steps, required this.current, super.key});

  /// Names of the steps, in order.
  final List<String> steps;

  /// Index of the step that is active now.
  final int current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Color colorOf(int index) {
      if (index < current) return scheme.success;
      if (index == current) return scheme.primary;
      return scheme.onSurfaceVariant.withValues(alpha: 0.6);
    }

    return Semantics(
      label: 'Step ${current + 1} of ${steps.length}: ${steps[current]}',
      excludeSemantics: true,
      child: SoftSurface(
        radius: 22,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            CapsLabel(
              'Step ${current + 1} of ${steps.length}',
              color: scheme.primary,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final index in Iterable<int>.generate(steps.length)) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 6,
                          decoration: ShapeDecoration(
                            shape: const StadiumBorder(),
                            color: index <= current
                                ? colorOf(index)
                                : context.depth.pressed,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          steps[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorOf(index),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
