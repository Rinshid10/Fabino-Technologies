import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/pills.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// Visual tone of a [StatusCard].
enum StatusTone { neutral, good, warning, bad }

/// How a [StatusCard] is laid out.
enum StatusCardLayout {
  /// A standalone card: icon on top, text below.
  tile,

  /// A compact row for use inside a panel: icon left, text right.
  row,
}

/// Sets the [StatusCardLayout] for every [StatusCard] below it, so a
/// screen can arrange the same cards as tiles or as rows.
class StatusCardTheme extends InheritedWidget {
  const StatusCardTheme({
    required this.layout,
    required super.child,
    super.key,
  });

  final StatusCardLayout layout;

  static StatusCardLayout of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<StatusCardTheme>();
    return theme?.layout ?? StatusCardLayout.tile;
  }

  @override
  bool updateShouldNotify(StatusCardTheme oldWidget) {
    return layout != oldWidget.layout;
  }
}

/// One piece of status: icon, title, value and an optional detail line.
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
    final detail = this.detail;

    final layout = StatusCardTheme.of(context);
    final titleText = layout == StatusCardLayout.row
        ? Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.085,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : CapsLabel(title);
    // Short values fit in a pill at the end of a row; long ones (such as
    // coordinates) go under the title.
    final isPillValue = value.length <= 12;
    final valueText = isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        : Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: layout == StatusCardLayout.tile ? null : toneColor,
              fontSize: layout == StatusCardLayout.tile ? 17 : 13,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.085,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
    final detailText = detail == null || isLoading
        ? null
        : Text(
            detail,
            style: layout == StatusCardLayout.tile
                ? theme.textTheme.labelSmall?.copyWith(
                    color: toneColor == scheme.primary
                        ? scheme.success
                        : toneColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.44,
                  )
                : theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
    final chevron = onTap == null
        ? null
        : Icon(Icons.chevron_right, size: 20, color: scheme.onSurfaceVariant);

    return switch (layout) {
      StatusCardLayout.row => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(
            children: [
              SoftIconWell(icon: icon, color: toneColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titleText,
                    if (isLoading || !isPillValue) ...[
                      const SizedBox(height: 2),
                      valueText,
                    ],
                    ?detailText,
                  ],
                ),
              ),
              if (!isLoading && isPillValue) ...[
                const SizedBox(width: 8),
                StatusPill(label: value, color: toneColor, uppercase: false),
              ],
              ?chevron,
            ],
          ),
        ),
      ),
      StatusCardLayout.tile => SoftPressable(
        onTap: onTap,
        semanticLabel: title,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SoftIconWell(icon: icon, color: toneColor, size: 32),
                const Spacer(),
                ?chevron,
              ],
            ),
            const SizedBox(height: 8),
            titleText,
            const SizedBox(height: 2),
            valueText,
            if (detailText != null) ...[
              const SizedBox(height: 4),
              detailText,
            ],
          ],
        ),
      ),
    };
  }
}
