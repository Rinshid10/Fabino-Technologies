import 'package:flutter/material.dart';

/// Colours for the app's surfaces: cards sit slightly above the
/// background, separated by a very soft shadow rather than borders.
@immutable
class DepthTheme extends ThemeExtension<DepthTheme> {
  const DepthTheme({
    required this.card,
    required this.pressed,
    required this.shadow,
  });

  /// Fill of cards, panels and keys.
  final Color card;

  /// Fill of a card while it is pressed or selected.
  final Color pressed;

  /// Colour of the soft shadow under cards.
  final Color shadow;

  @override
  DepthTheme copyWith({Color? card, Color? pressed, Color? shadow}) {
    return DepthTheme(
      card: card ?? this.card,
      pressed: pressed ?? this.pressed,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  DepthTheme lerp(DepthTheme? other, double t) {
    if (other == null) return this;
    return DepthTheme(
      card: Color.lerp(card, other.card, t)!,
      pressed: Color.lerp(pressed, other.pressed, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Material 3 themes for the app: a quiet background, clean cards, one
/// accent colour and no decoration beyond a soft shadow.
abstract final class AppTheme {
  static const _seed = Color(0xFF3D6DEB);

  /// Bundled with the app, so it works offline.
  static const fontFamily = 'PlusJakartaSans';

  static const _lightBackground = Color(0xFFF8F9FF);
  static const _darkBackground = Color(0xFF14161A);

  static const _lightDepth = DepthTheme(
    card: Color(0xFFFFFFFF),
    pressed: Color(0xFFEFF4FF),
    shadow: Color(0x141B2A4A),
  );
  static const _darkDepth = DepthTheme(
    card: Color(0xFF1D2025),
    pressed: Color(0xFF282C33),
    shadow: Color(0x33000000),
  );

  /// The surface colours that belong to [brightness].
  static DepthTheme depthFor(Brightness brightness) {
    return brightness == Brightness.light ? _lightDepth : _darkDepth;
  }

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final background = isLight ? _lightBackground : _darkBackground;
    final depth = depthFor(brightness);
    final onSurface = isLight ? const Color(0xFF0B1C30) : null;
    final onSurfaceVariant = isLight ? const Color(0xFF434654) : null;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: brightness,
        ).copyWith(
          primary: isLight ? _seed : const Color(0xFF8CA8FF),
          onPrimary: isLight ? Colors.white : const Color(0xFF0E1B3D),
          surface: background,
          onSurface: onSurface,
          onSurfaceVariant: onSurfaceVariant,
          error: isLight ? const Color(0xFFBA1A1A) : null,
          surfaceContainerLowest: depth.card,
          surfaceContainerLow: depth.card,
          surfaceContainer: depth.card,
          surfaceContainerHigh: depth.card,
          surfaceContainerHighest: depth.pressed,
        );
    const buttonShape = StadiumBorder();
    const menuShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      extensions: [depth],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: depth.card,
        indicatorColor: scheme.primary.withValues(alpha: 0.12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 56),
          shape: buttonShape,
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 56),
          shape: buttonShape,
          backgroundColor: depth.pressed,
          side: BorderSide.none,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
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
        elevation: 2,
        highlightElevation: 2,
        shape: buttonShape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: depth.card,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: depth.card,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: menuShape,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: depth.pressed,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: menuShape,
      ),
    );
  }
}

/// Access to the surface colours from a [BuildContext].
extension DepthContext on BuildContext {
  /// Falls back to the built-in colours when a theme (for example in a
  /// widget test) does not carry the extension.
  DepthTheme get depth {
    final theme = Theme.of(this);
    return theme.extension<DepthTheme>() ?? AppTheme.depthFor(theme.brightness);
  }
}

/// Semantic colours that are not part of [ColorScheme].
extension StatusColors on ColorScheme {
  Color get success => brightness == Brightness.light
      ? const Color(0xFF006C49)
      : const Color(0xFF7BD992);

  Color get warning => brightness == Brightness.light
      ? const Color(0xFF835200)
      : const Color(0xFFF2BE5C);
}
