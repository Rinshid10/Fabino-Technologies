import 'package:flutter/material.dart';

/// Material 3 themes for the app.
abstract final class AppTheme {
  static const _seed = Color(0xFF1F5FBF);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Semantic colours that are not part of [ColorScheme].
extension StatusColors on ColorScheme {
  Color get success => brightness == Brightness.light
      ? const Color(0xFF1B7F3B)
      : const Color(0xFF7BD992);

  Color get warning => brightness == Brightness.light
      ? const Color(0xFF9A6200)
      : const Color(0xFFF2BE5C);
}
