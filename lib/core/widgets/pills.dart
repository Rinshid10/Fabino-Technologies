import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';

/// A small rounded label on a tint of its own colour, such as "ENABLED".
class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    this.color,
    this.icon,
    this.showDot = true,
    this.uppercase = true,
    super.key,
  });

  final String label;

  /// Colour of the text and dot; the background is a faint tint of it.
  final Color? color;

  /// Shown instead of the dot.
  final IconData? icon;
  final bool showDot;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tone = color ?? theme.colorScheme.primary;
    final icon = this.icon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: tone.withValues(alpha: 0.13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: tone),
            const SizedBox(width: 6),
          ] else if (showDot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(shape: BoxShape.circle, color: tone),
            ),
            const SizedBox(width: 7),
          ],
          Flexible(
            child: Text(
              uppercase ? label.toUpperCase() : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: tone,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: uppercase ? 0.6 : 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A flat, lightly tinted box for details inside a card.
class InsetPanel extends StatelessWidget {
  const InsetPanel({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 18,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.depth.pressed,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

/// A round icon button on a card-coloured circle with a soft shadow.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.size = 46,
    this.isFlat = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  /// Draws the circle in the inset colour without a shadow, for use on
  /// top of a card.
  final bool isFlat;

  @override
  Widget build(BuildContext context) {
    final depth = context.depth;
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: Material(
          color: isFlat ? depth.pressed : depth.card,
          shape: const CircleBorder(),
          elevation: isFlat ? 0 : 3,
          shadowColor: depth.shadow.withValues(alpha: 0.35),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child: Icon(
                icon,
                size: size * 0.46,
                color: onPressed == null
                    ? scheme.onSurface.withValues(alpha: 0.3)
                    : color ?? scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small uppercase caption, such as "COORDINATES".
class CapsLabel extends StatelessWidget {
  const CapsLabel(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelSmall?.copyWith(
        color: color ?? theme.colorScheme.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
