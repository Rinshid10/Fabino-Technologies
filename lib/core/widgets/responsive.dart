import 'package:flutter/material.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';

/// Screen-size helpers.
extension ResponsiveContext on BuildContext {
  /// True on tablets and other wide layouts.
  bool get isWide => MediaQuery.sizeOf(this).width >= Breakpoints.tablet;
}

/// Centres [child] and caps its width so content stays readable on tablets.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
