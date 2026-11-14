import 'package:flutter/material.dart';

/// The dashboard title with a shield badge on the right.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            'Security dashboard',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const ShieldBadge(),
      ],
    );
  }
}

/// A blue shield with a lock, sitting on a soft halo.
class ShieldBadge extends StatelessWidget {
  const ShieldBadge({this.size = 76, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final lighter = Color.lerp(primary, Colors.white, 0.35)!;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Halo.
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.1),
            ),
          ),
          // Shield with a top-to-bottom gradient and a soft drop shadow.
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  offset: Offset(0, size * 0.1),
                  blurRadius: size * 0.22,
                  spreadRadius: -size * 0.12,
                ),
              ],
            ),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [lighter, primary],
              ).createShader(bounds),
              child: Icon(Icons.shield, size: size * 0.78),
            ),
          ),
          Icon(Icons.lock, size: size * 0.3, color: Colors.white),
        ],
      ),
    );
  }
}
