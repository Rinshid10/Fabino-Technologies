import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_verification.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_rules.dart';
import 'package:smart_access_security/features/auth/presentation/auth_labels.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/auth_controller.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/pin_entry_view.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/step_progress.dart';

enum _Step { current, newPin, confirm }

/// Change the PIN: verify the current one, then enter the new one twice.
class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  _Step _step = _Step.current;
  String? _newPin;
  String? _error;
  DateTime? _lockedUntil;

  Future<void> _onPinEntered(String pin) async {
    switch (_step) {
      case _Step.current:
        await _verifyCurrent(pin);
      case _Step.newPin:
        final problem = PinRules.validate(pin);
        setState(() {
          _error = problem;
          if (problem == null) {
            _newPin = pin;
            _step = _Step.confirm;
          }
        });
      case _Step.confirm:
        await _confirm(pin);
    }
  }

  Future<void> _verifyCurrent(String pin) async {
    final result = await ref.read(authControllerProvider).verifyPin(pin);
    if (!mounted) return;
    setState(() {
      _error = result.errorMessage;
      _lockedUntil = result.lockedUntil;
      if (result is PinAccepted) _step = _Step.newPin;
    });
  }

  Future<void> _confirm(String pin) async {
    if (pin != _newPin) {
      setState(() {
        _step = _Step.newPin;
        _newPin = null;
        _error = 'The PINs did not match. Enter the new PIN again.';
      });
      return;
    }

    await ref.read(authControllerProvider).savePin(pin);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('PIN changed.')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = switch (_step) {
      _Step.current => ('Current PIN', 'Enter your current PIN to continue.'),
      _Step.newPin => ('New PIN', 'Choose a new PIN.'),
      _Step.confirm => ('Confirm new PIN', 'Enter the new PIN again.'),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Change PIN')),
      body: PinEntryView(
        // A new key resets the entered digits when the step changes.
        key: ValueKey(_step),
        icon: Icons.password,
        header: StepProgress(
          steps: const ['Current', 'New PIN', 'Confirm'],
          current: _step.index,
        ),
        title: title,
        subtitle: subtitle,
        errorText: _error,
        lockedUntil: _lockedUntil,
        onLockoutExpired: () => setState(() {
          _lockedUntil = null;
          _error = null;
        }),
        onCompleted: _onPinEntered,
      ),
    );
  }
}
