import 'package:flutter/material.dart';

/// A soft gradient with two gentle waves in the bottom corner, drawn
/// behind a screen's content.
class PastelBackground extends StatelessWidget {
  const PastelBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.scaffoldBackgroundColor;
    final accent = theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            base,
            Color.alphaBlend(accent.withValues(alpha: 0.07), base),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _WavePainter(accent),
        child: child,
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // A wide, faint wave behind a smaller, slightly stronger one.
    final back = Path()
      ..moveTo(width, height * 0.72)
      ..quadraticBezierTo(width * 0.62, height * 0.78, width * 0.42, height)
      ..lineTo(width, height)
      ..close();
    final front = Path()
      ..moveTo(width, height * 0.84)
      ..quadraticBezierTo(width * 0.78, height * 0.86, width * 0.64, height)
      ..lineTo(width, height)
      ..close();

    canvas
      ..drawPath(back, Paint()..color = color.withValues(alpha: 0.06))
      ..drawPath(front, Paint()..color = color.withValues(alpha: 0.08));
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => color != oldDelegate.color;
}
