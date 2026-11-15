import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/core/widgets/floating_nav_bar.dart';

const _items = [
  FloatingNavItem(
    label: 'Dashboard',
    icon: Icons.shield_outlined,
    selectedIcon: Icons.shield,
  ),
  FloatingNavItem(
    label: 'Map',
    icon: Icons.map_outlined,
    selectedIcon: Icons.map,
  ),
  FloatingNavItem(
    label: 'Tracking',
    icon: Icons.route_outlined,
    selectedIcon: Icons.route,
  ),
  FloatingNavItem(
    label: 'Geofences',
    icon: Icons.radar_outlined,
    selectedIcon: Icons.radar,
  ),
  FloatingNavItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];

void main() {
  Future<void> pumpBar(
    WidgetTester tester, {
    required int selectedIndex,
    ValueChanged<int>? onSelected,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: FloatingNavBar(
            items: _items,
            selectedIndex: selectedIndex,
            onSelected: onSelected ?? (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('shows every item and the filled icon for the selected one', (
    tester,
  ) async {
    await pumpBar(tester, selectedIndex: 1);

    for (final item in _items) {
      expect(find.text(item.label), findsOneWidget);
    }
    expect(find.byIcon(Icons.map), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    expect(find.byIcon(Icons.shield), findsNothing);
  });

  testWidgets('reports the tapped item', (tester) async {
    final taps = <int>[];
    await pumpBar(tester, selectedIndex: 0, onSelected: taps.add);

    await tester.tap(find.text('Geofences'));
    await tester.tap(find.byIcon(Icons.settings_outlined));

    expect(taps, [3, 4]);
  });

  testWidgets('marks the selected item for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpBar(tester, selectedIndex: 2);

    expect(
      tester.getSemantics(find.bySemanticsLabel('Tracking')),
      matchesSemantics(
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
        label: 'Tracking',
      ),
    );
    handle.dispose();
  });

  testWidgets('fits a small phone with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    await pumpBar(tester, selectedIndex: 0);

    expect(tester.takeException(), isNull);
  });
}
