import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';

/// One entry of a [FloatingNavBar].
class FloatingNavItem {
  const FloatingNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// A bottom navigation bar that floats above the screen edge as a rounded
/// card. A solid capsule slides behind the selected item.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<FloatingNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _height = 56.0;
  static const _indicatorSize = Size(76, 44);
  static const _indicatorTop = 6.0;
  static const _duration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final depth = context.depth;

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.2,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: depth.card,
            borderRadius: BorderRadius.circular(_height / 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 15,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SizedBox(
            height: _height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;
                final indicatorWidth = _indicatorSize.width.clamp(
                  0.0,
                  itemWidth - 4,
                );
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: _duration,
                      curve: Curves.easeOutCubic,
                      left:
                          itemWidth * selectedIndex +
                          (itemWidth - indicatorWidth) / 2,
                      top: _indicatorTop,
                      width: indicatorWidth,
                      height: _indicatorSize.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (final (index, item) in items.indexed)
                          Expanded(
                            child: _NavItem(
                              item: item,
                              isSelected: index == selectedIndex,
                              onTap: () {
                                unawaited(HapticFeedback.selectionClick());
                                onSelected(index);
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final FloatingNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: FloatingNavBar._indicatorTop + 5),
            SizedBox(
              height: 20,
              child: AnimatedSwitcher(
                duration: FloatingNavBar._duration,
                child: Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  key: ValueKey(isSelected),
                  size: 20,
                  color: isSelected ? scheme.onPrimary : scheme.muted,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedDefaultTextStyle(
                duration: FloatingNavBar._duration,
                style: (theme.textTheme.labelSmall ?? const TextStyle())
                    .copyWith(
                      fontSize: 10,
                      height: 1.5,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? scheme.onPrimary : scheme.muted,
                    ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
