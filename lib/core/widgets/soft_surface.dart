import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';

/// The app's basic surface: a clean card with rounded corners and one
/// very soft shadow. With [isPressed] it turns flat and slightly tinted,
/// which is also how a selected item looks.
class SoftSurface extends StatelessWidget {
  const SoftSurface({
    required this.child,
    this.radius = 28,
    this.isPressed = false,
    this.isCircle = false,
    this.padding,
    super.key,
  });

  final Widget child;
  final double radius;
  final bool isPressed;
  final bool isCircle;
  final EdgeInsetsGeometry? padding;

  static const _animation = Duration(milliseconds: 180);

  @override
  Widget build(BuildContext context) {
    final colors = context.depth;

    return AnimatedContainer(
      duration: _animation,
      curve: Curves.easeOut,
      padding: padding,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(radius),
        color: isPressed ? colors.pressed : colors.card,
        boxShadow: [
          BoxShadow(
            color: isPressed ? Colors.transparent : colors.shadow,
            offset: const Offset(0, 4),
            blurRadius: 24,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A [SoftSurface] that responds to touch with a smooth, slight shrink.
///
/// With a `null` [onTap] it is a plain surface (or a faded one when
/// [fadeWhenDisabled] is set, for disabled buttons).
class SoftPressable extends StatefulWidget {
  const SoftPressable({
    required this.child,
    this.onTap,
    this.radius = 28,
    this.isCircle = false,
    this.padding,
    this.fadeWhenDisabled = false,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final bool isCircle;
  final EdgeInsetsGeometry? padding;
  final bool fadeWhenDisabled;
  final String? semanticLabel;

  @override
  State<SoftPressable> createState() => _SoftPressableState();
}

class _SoftPressableState extends State<SoftPressable> {
  bool _isDown = false;

  void _setDown(bool value) {
    if (widget.onTap != null && _isDown != value) {
      setState(() => _isDown = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onTap;
    final surface = SoftSurface(
      radius: widget.radius,
      isCircle: widget.isCircle,
      isPressed: _isDown,
      padding: widget.padding,
      child: widget.child,
    );
    if (onTap == null) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: widget.fadeWhenDisabled ? 0.45 : 1,
        child: surface,
      );
    }

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setDown(true),
        onTapUp: (_) => _setDown(false),
        onTapCancel: () => _setDown(false),
        onTap: onTap,
        child: AnimatedScale(
          scale: _isDown ? 0.97 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: surface,
        ),
      ),
    );
  }
}

/// An icon on a flat, lightly tinted circle.
class SoftIconWell extends StatelessWidget {
  const SoftIconWell({
    required this.icon,
    this.color,
    this.size = 40,
    super.key,
  });

  final IconData icon;

  /// Colour of the icon; the circle uses a faint tint of it.
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tone = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tone.withValues(alpha: 0.1),
      ),
      child: Icon(icon, size: size * 0.5, color: tone),
    );
  }
}
