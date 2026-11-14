import 'package:flutter/material.dart';

/// Numeric keypad: digits 1-9, then [action] (optional), 0 and backspace.
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
            Row(children: [for (final digit in row) _digitKey(digit)]),
          Row(
            children: [
              _PadSlot(child: action),
              _digitKey('0'),
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

  Widget _digitKey(String digit) {
    return _PadSlot(
      child: FilledButton.tonal(
        key: ValueKey('pin-key-$digit'),
        onPressed: enabled ? () => onDigit(digit) : null,
        style: FilledButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 24),
        ),
        child: Text(digit),
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
        aspectRatio: 1.25,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: child == null ? null : SizedBox.expand(child: child),
        ),
      ),
    );
  }
}
