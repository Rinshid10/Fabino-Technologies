import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';

/// The building block of the app's soft 3D look.
///
/// It has the same colour as the background and gets its shape purely
/// from light and shadow: raised by default, or pressed into the surface
/// with [isPressed].
class SoftSurface extends StatelessWidget {
  const SoftSurface({
    required this.child,
    this.radius = 22,
    this.depth = 6,
    this.isPressed = false,
    this.isCircle = false,
    this.padding,
    super.key,
  });

  final Widget child;
  final double radius;

  /// How far the surface appears to stand out, in logical pixels.
  final double depth;
  final bool isPressed;
  final bool isCircle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).scaffoldBackgroundColor;
    final colors = context.depth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: padding,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(radius),
        color: isPressed ? null : base,
        // A pressed surface is lit the other way round: dark at the
        // top-left rim, light at the bottom-right.
        gradient: isPressed
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(colors.shadow.withValues(alpha: 0.45), base),
                  Color.alphaBlend(
                    colors.highlight.withValues(alpha: 0.6),
                    base,
                  ),
                ],
              )
            : null,
        boxShadow: isPressed
            ? null
            : [
                BoxShadow(
                  color: colors.shadow,
                  offset: Offset(depth, depth),
                  blurRadius: depth * 2.2,
                ),
                BoxShadow(
                  color: colors.highlight,
                  offset: Offset(-depth, -depth),
                  blurRadius: depth * 2.2,
                ),
              ],
      ),
      child: child,
    );
  }
}

/// A [SoftSurface] that sinks in while it is being pressed.
///
/// With a `null` [onTap] it is a plain raised surface (or a faded one when
/// [fadeWhenDisabled] is set, for disabled buttons).
class SoftPressable extends StatefulWidget {
  const SoftPressable({
    required this.child,
    this.onTap,
    this.radius = 22,
    this.depth = 6,
    this.isCircle = false,
    this.padding,
    this.fadeWhenDisabled = false,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final double depth;
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
      depth: widget.depth,
      isCircle: widget.isCircle,
      isPressed: _isDown,
      padding: widget.padding,
      child: widget.child,
    );
    if (onTap == null) {
      return Opacity(
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
        child: surface,
      ),
    );
  }
}

/// A small round well, pressed into the surface, that holds an icon.
class SoftIconWell extends StatelessWidget {
  const SoftIconWell({
    required this.icon,
    this.color,
    this.size = 40,
    super.key,
  });

  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: SoftSurface(
        isCircle: true,
        isPressed: true,
        child: Icon(icon, size: size * 0.5, color: color),
      ),
    );
  }
}
