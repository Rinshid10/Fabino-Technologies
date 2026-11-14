import 'package:flutter/material.dart';
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

  /// Extra key shown bottom-left, for example a biometric button.
  final Widget? action;
  final bool enabled;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
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
                child: IconButton(
                  tooltip: 'Delete',
                  onPressed: enabled ? onBackspace : null,
                  icon: const Icon(Icons.backspace_outlined),
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
    return _PadSlot(
      child: SoftPressable(
        key: ValueKey('pin-key-$digit'),
        isCircle: true,
        fadeWhenDisabled: true,
        semanticLabel: digit,
        onTap: enabled ? () => onDigit(digit) : null,
        child: Center(
          child: Text(
            digit,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
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
          padding: const EdgeInsets.all(11),
          child: child == null ? null : SizedBox.expand(child: child),
        ),
      ),
    );
  }
}
