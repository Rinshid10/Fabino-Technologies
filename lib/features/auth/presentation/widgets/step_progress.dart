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

    return Semantics(
      label: 'Step ${current + 1} of ${steps.length}: ${steps[current]}',
      excludeSemantics: true,
      child: SoftSurface(
        radius: 12,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: CapsLabel(
                    'Step ${current + 1} of ${steps.length}',
                    color: scheme.primaryDeep,
                  ),
                ),
                Text(
                  steps[current],
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final index in Iterable<int>.generate(steps.length)) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 6,
                      decoration: ShapeDecoration(
                        shape: const StadiumBorder(),
                        color: index < current
                            ? scheme.success
                            : index == current
                            ? scheme.primary
                            : scheme.pillFill(scheme.primary),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final (index, step) in steps.indexed)
                  Expanded(
                    child: _StepLabel(
                      text: step,
                      isDone: index < current,
                      isCurrent: index == current,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({
    required this.text,
    required this.isDone,
    required this.isCurrent,
  });

  final String text;
  final bool isDone;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = isDone
        ? scheme.success
        : isCurrent
        ? scheme.primaryDeep
        : scheme.onSurfaceVariant.withValues(alpha: 0.6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isDone)
          Icon(Icons.check_circle_outline, size: 12, color: color)
        else if (isCurrent)
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        if (isDone || isCurrent) const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 11,
              height: 14 / 11,
              fontWeight: isDone ? FontWeight.w500 : FontWeight.w700,
              letterSpacing: 0.44,
            ),
          ),
        ),
      ],
    );
  }
}
