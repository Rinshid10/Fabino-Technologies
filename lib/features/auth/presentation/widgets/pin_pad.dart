import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';

/// Numeric keypad: digits 1-9, then [action] (optional), 0 and backspace.
/// Every key is a 72 px circle.
class PinPad extends StatelessWidget {
  const PinPad({
    required this.onDigit,
    required this.onBackspace,
    this.action,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  /// Extra key shown bottom-left, for example a [PinPadActionKey].
  final Widget? action;
  final bool enabled;

  static const _keySize = 72.0;
  static const _rowGap = 16.0;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  /// The letters printed under each digit, as on a phone keypad.
  static const _letters = {
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
    '0': '+',
  };

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in _rows) ...[
            Row(children: [for (final digit in row) _digitKey(digit)]),
            const SizedBox(height: _rowGap),
          ],
          Row(
            children: [
              _PadSlot(child: action),
              _digitKey('0'),
              _PadSlot(
                child: PinPadActionKey(
                  icon: Icons.backspace_outlined,
                  tooltip: 'Delete',
                  onPressed: enabled ? onBackspace : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _digitKey(String digit) {
    return _PadSlot(
      child: _DigitKey(
        key: ValueKey('pin-key-$digit'),
        digit: digit,
        letters: _letters[digit],
        onTap: enabled ? () => onDigit(digit) : null,
      ),
    );
  }
}

/// A white round key with a digit and, under it, its letters.
class _DigitKey extends StatelessWidget {
  const _DigitKey({
    required this.digit,
    required this.letters,
    required this.onTap,
    super.key,
  });

  final String digit;
  final String? letters;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final letters = this.letters;

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: digit,
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: onTap == null ? 0.45 : 1,
        child: Material(
          color: context.depth.card,
          shape: const CircleBorder(),
          elevation: 1,
          shadowColor: const Color(0x33000000),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  digit,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                // An empty line keeps "1" level with the other digits.
                Text(
                  letters ?? '',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.muted,
                    fontSize: 11,
                    height: 14 / 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.55,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A flat, tinted key of the [PinPad] for actions that are not digits.
class PinPadActionKey extends StatelessWidget {
  const PinPadActionKey({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.label,
    this.isAccent = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  /// Short text under the icon.
  final String? label;

  /// Draws the icon and label in the primary colour.
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = this.label;
    final color = onPressed == null
        ? scheme.onSurface.withValues(alpha: 0.3)
        : isAccent
        ? scheme.primaryDeep
        : scheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: Material(
          color: context.depth.pressed,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: color),
                if (label != null) ...[
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontSize: 11,
                        height: 14 / 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.44,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One cell of the keypad, holding a centred 72 px key.
class _PadSlot extends StatelessWidget {
  const _PadSlot({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox.square(dimension: PinPad._keySize, child: child),
      ),
    );
  }
}
