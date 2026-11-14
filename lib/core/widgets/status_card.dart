import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// Visual tone of a [StatusCard].
enum StatusTone { neutral, good, warning, bad }

/// A white card showing one piece of status. Its tone colours the left
/// edge, the icon circle and the value.
class StatusCard extends StatelessWidget {
  const StatusCard({
    required this.icon,
    required this.title,
    required this.value,
    this.detail,
    this.tone = StatusTone.neutral,
    this.onTap,
    this.isLoading = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? detail;
  final StatusTone tone;
  final VoidCallback? onTap;
  final bool isLoading;

  static const _radius = 26.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final toneColor = switch (tone) {
      StatusTone.neutral => scheme.primary,
      StatusTone.good => scheme.success,
      StatusTone.warning => scheme.warning,
      StatusTone.bad => scheme.error,
    };
    final detail = this.detail;

    return SoftPressable(
      onTap: onTap,
      semanticLabel: title,
      radius: _radius,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Stack(
          children: [
            // The coloured edge that follows the card's rounded corner.
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 5,
              child: ColoredBox(color: toneColor.withValues(alpha: 0.45)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SoftIconWell(icon: icon, color: toneColor, size: 46),
                      const Spacer(),
                      if (onTap != null)
                        Icon(
                          Icons.chevron_right,
                          color: scheme.onSurfaceVariant,
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    Text(
                      value,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: toneColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (detail != null && !isLoading) ...[
                    const SizedBox(height: 6),
                    Text(
                      detail,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
