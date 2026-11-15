import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// Numeric keypad: digits 1-9, then [action] (optional), 0 and backspace.
/// Every key is a round button that shrinks slightly when pressed.
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
          for (final row in _rows)
            Row(children: [for (final digit in row) _digitKey(context, digit)]),
          Row(
            children: [
              _PadSlot(child: action),
              _digitKey(context, '0'),
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

  Widget _digitKey(BuildContext context, String digit) {
    final theme = Theme.of(context);
    final letters = _letters[digit];
    return _PadSlot(
      child: SoftPressable(
        key: ValueKey('pin-key-$digit'),
        isCircle: true,
        fadeWhenDisabled: true,
        semanticLabel: digit,
        onTap: enabled ? () => onDigit(digit) : null,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                digit,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              if (letters != null)
                ExcludeSemantics(
                  child: Text(
                    letters,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
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
        ? scheme.primary
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
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 26, color: color),
                  if (label != null)
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One equally sized square cell of the keypad.
class _PadSlot extends StatelessWidget {
  const _PadSlot({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: child == null ? null : SizedBox.expand(child: child),
        ),
      ),
    );
  }
}
