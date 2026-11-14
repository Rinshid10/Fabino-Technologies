import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// Visual tone of a [StatusCard].
enum StatusTone { neutral, good, warning, bad }

/// A raised card showing one piece of status: icon, title, value, detail.
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

    return SoftPressable(
      onTap: onTap,
      semanticLabel: title,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SoftIconWell(icon: icon, color: toneColor),
              const Spacer(),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (isLoading)
            const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: toneColor,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (detail != null && !isLoading) ...[
            const SizedBox(height: 4),
            Text(
              detail!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
