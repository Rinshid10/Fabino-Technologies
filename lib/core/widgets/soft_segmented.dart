import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// One choice of a [SoftSegmented] control.
typedef SoftSegment<T> = ({T value, IconData icon, String label});

/// A row of raised buttons where the selected one stays pressed in.
class SoftSegmented<T> extends StatelessWidget {
  const SoftSegmented({
    required this.segments,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<SoftSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        for (final (index, segment) in segments.indexed) ...[
          if (index > 0) const SizedBox(width: 16),
          Expanded(
            child: Semantics(
              button: true,
              selected: segment.value == selected,
              label: segment.label,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(segment.value),
                child: SoftSurface(
                  radius: 18,
                  isPressed: segment.value == selected,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        segment.icon,
                        color: segment.value == selected
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        segment.label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: segment.value == selected
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
