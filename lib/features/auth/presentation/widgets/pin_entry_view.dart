import 'package:flutter/material.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/pills.dart';

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
    this.header,
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

  /// Shown above the icon, for example a step indicator.
  final Widget? header;

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.header != null) ...[
                widget.header!,
                const SizedBox(height: 24),
              ],
              _HeroIcon(icon: widget.icon),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 26,
                  height: 32 / 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.65,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.muted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: StatusPill(
                          label: errorText,
                          icon: Icons.error_outline,
                          color: theme.colorScheme.error,
                          uppercase: false,
                          maxLines: 3,
                        ),
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

/// The mark above the title: an icon in a white ring with a green "ready"
/// badge.
class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final depth = context.depth;

    return SizedBox.square(
      dimension: 80,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: depth.card,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: -1,
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: depth.pressed,
              ),
              child: Icon(icon, size: 28, color: scheme.primaryDeep),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.success,
              ),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: depth.card,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
