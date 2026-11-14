import 'package:flutter/material.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/lockout_countdown.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/pin_dots.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/pin_pad.dart';

/// Complete PIN entry UI: heading, dots, error / lockout text and keypad.
///
/// It collects digits and calls [onCompleted] with the full PIN. The lock,
/// set-up and change-PIN screens all reuse it and only decide what a
/// completed PIN means.
class PinEntryView extends StatefulWidget {
  const PinEntryView({
    required this.title,
    required this.onCompleted,
    this.subtitle,
    this.errorText,
    this.lockedUntil,
    this.onLockoutExpired,
    this.padAction,
    this.icon = Icons.lock_outline,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// Called with the PIN once all digits are entered. The pad is disabled
  /// until the returned future completes, then the digits are cleared.
  final Future<void> Function(String pin) onCompleted;
  final String? errorText;

  /// While this is in the future the pad is disabled and a countdown shows.
  final DateTime? lockedUntil;
  final VoidCallback? onLockoutExpired;

  /// Extra key shown bottom-left of the pad (for example biometrics).
  final Widget? padAction;
  final IconData icon;

  @override
  State<PinEntryView> createState() => _PinEntryViewState();
}

class _PinEntryViewState extends State<PinEntryView> {
  String _pin = '';
  bool _isSubmitting = false;

  bool get _isLockedOut {
    final until = widget.lockedUntil;
    return until != null && until.isAfter(DateTime.now());
  }

  Future<void> _addDigit(String digit) async {
    if (_isSubmitting || _pin.length >= kPinLength) return;
    setState(() => _pin += digit);
    if (_pin.length < kPinLength) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onCompleted(_pin);
    } finally {
      if (mounted) {
        setState(() {
          _pin = '';
          _isSubmitting = false;
        });
      }
    }
  }

  void _removeDigit() {
    if (_isSubmitting || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lockedUntil = widget.lockedUntil;
    final errorText = widget.errorText;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 28),
              if (_isSubmitting)
                const SizedBox.square(
                  dimension: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                PinDots(
                  length: kPinLength,
                  filled: _pin.length,
                  hasError: errorText != null && _pin.isEmpty,
                ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorText != null)
                      Text(
                        errorText,
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    if (lockedUntil != null && _isLockedOut)
                      LockoutCountdown(
                        key: ValueKey(lockedUntil),
                        until: lockedUntil,
                        onExpired: () {
                          if (mounted) setState(() {});
                          widget.onLockoutExpired?.call();
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              PinPad(
                enabled: !_isSubmitting && !_isLockedOut,
                onDigit: _addDigit,
                onBackspace: _removeDigit,
                action: widget.padAction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
