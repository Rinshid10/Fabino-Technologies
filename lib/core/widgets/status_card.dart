import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';

/// Visual tone of a [StatusCard].
enum StatusTone { neutral, good, warning, bad }

/// A compact card showing one piece of status: icon, title, value, detail.
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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, color: toneColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
                ],
              ),
              const SizedBox(height: 12),
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
                    fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }
}
