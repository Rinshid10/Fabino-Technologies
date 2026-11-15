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
/// card. A solid capsule slides behind the icon of the selected item.
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

  static const _height = 70.0;
  static const _indicatorSize = Size(56, 32);
  static const _indicatorTop = 8.0;
  static const _duration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final depth = context.depth;

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.2,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: depth.card,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: depth.shadow,
                blurRadius: 24,
                offset: const Offset(0, 8),
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
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
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
            const SizedBox(height: FloatingNavBar._indicatorTop),
            SizedBox(
              height: FloatingNavBar._indicatorSize.height,
              child: AnimatedSwitcher(
                duration: FloatingNavBar._duration,
                child: Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  key: ValueKey(isSelected),
                  size: 22,
                  color: isSelected
                      ? scheme.onPrimary
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedDefaultTextStyle(
                duration: FloatingNavBar._duration,
                style: (theme.textTheme.labelSmall ?? const TextStyle())
                    .copyWith(
                      fontSize: 11,
                      letterSpacing: 0,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
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
