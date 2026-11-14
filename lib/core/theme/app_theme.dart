import 'package:flutter/material.dart';

/// The two colours that create the soft 3D look: a light edge towards the
/// top-left and a shadow towards the bottom-right of every raised surface.
@immutable
class DepthTheme extends ThemeExtension<DepthTheme> {
  const DepthTheme({required this.highlight, required this.shadow});

  final Color highlight;
  final Color shadow;

  @override
  DepthTheme copyWith({Color? highlight, Color? shadow}) {
    return DepthTheme(
      highlight: highlight ?? this.highlight,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  DepthTheme lerp(DepthTheme? other, double t) {
    if (other == null) return this;
    return DepthTheme(
      highlight: Color.lerp(highlight, other.highlight, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Material 3 themes for the app: one calm base colour that every surface
/// shares, depth from light and shadow, and a single accent colour.
abstract final class AppTheme {
  static const _seed = Color(0xFF3D6DEB);

  static const _lightBase = Color(0xFFE8ECF2);
  static const _darkBase = Color(0xFF25282D);

  static const _lightDepth = DepthTheme(
    highlight: Color(0xFFFFFFFF),
    shadow: Color(0xFFB4BFD0),
  );
  static const _darkDepth = DepthTheme(
    highlight: Color(0xFF32363C),
    shadow: Color(0xFF15171A),
  );

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final base = isLight ? _lightBase : _darkBase;
    final depth = isLight ? _lightDepth : _darkDepth;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: brightness,
        ).copyWith(
          primary: isLight ? _seed : const Color(0xFF8CA8FF),
          onPrimary: isLight ? Colors.white : const Color(0xFF0E1B3D),
          surface: base,
          surfaceContainerLowest: base,
          surfaceContainerLow: base,
          surfaceContainer: base,
          surfaceContainerHigh: base,
          surfaceContainerHighest: Color.alphaBlend(
            depth.shadow.withValues(alpha: 0.25),
            base,
          ),
        );
    const buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: base,
      extensions: [depth],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: base,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: base,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shadowColor: depth.shadow,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        height: 68,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: base,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: buttonShape,
          elevation: 6,
          shadowColor: scheme.primary.withValues(alpha: 0.5),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: buttonShape,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 8,
        shape: buttonShape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: base,
        surfaceTintColor: Colors.transparent,
        elevation: 16,
        shadowColor: depth.shadow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: base,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shadowColor: depth.shadow,
        shape: buttonShape,
      ),
      // Text fields look pressed into the surface.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color.alphaBlend(depth.shadow.withValues(alpha: 0.22), base),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: depth.shadow.withValues(alpha: 0.35),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: buttonShape,
      ),
    );
  }
}

/// Access to the depth colours from a [BuildContext].
extension DepthContext on BuildContext {
  DepthTheme get depth => Theme.of(this).extension<DepthTheme>()!;
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
