import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/core/widgets/confirm_dialog.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_rules.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/auth_controller.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/pin_entry_view.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/step_progress.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';

/// First-launch screen: choose a PIN, confirm it, optionally enable
/// biometric unlock.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  /// The PIN from the first step, or `null` while still on the first step.
  String? _firstPin;
  String? _error;

  Future<void> _onPinEntered(String pin) async {
    final firstPin = _firstPin;

    if (firstPin == null) {
      final problem = PinRules.validate(pin);
      setState(() {
        _error = problem;
        if (problem == null) _firstPin = pin;
      });
      return;
    }

    if (pin != firstPin) {
      setState(() {
        _firstPin = null;
        _error = 'The PINs did not match. Start again.';
      });
      return;
    }

    final auth = ref.read(authControllerProvider);
    await auth.savePin(pin);
    await _offerBiometrics();
    auth.completeSetup();
  }

  Future<void> _offerBiometrics() async {
    final status = await ref.read(biometricStatusProvider.future);
    if (!status.isAvailable || !mounted) return;

    final enable = await showConfirmDialog(
      context,
      title: 'Use biometrics?',
      message:
          'Unlock faster with your fingerprint or face. Your PIN always '
          'works as a fallback.',
      confirmLabel: 'Enable',
    );
    if (!enable) return;
    await ref
        .read(settingsControllerProvider.notifier)
        .setBiometricsEnabled(enabled: true);
  }

  @override
  Widget build(BuildContext context) {
    final isConfirming = _firstPin != null;
    return Scaffold(
      body: PinEntryView(
        // A new key resets the entered digits when the step changes.
        key: ValueKey(isConfirming),
        icon: Icons.shield_outlined,
        header: StepProgress(
          steps: const ['Create', 'Confirm'],
          current: isConfirming ? 1 : 0,
        ),
        title: isConfirming ? 'Confirm your PIN' : 'Create a PIN',
        subtitle: isConfirming
            ? 'Enter the same $kPinLength digits again.'
            : 'This $kPinLength-digit PIN protects the app. It is stored '
                  'only on this device, as a salted hash.',
        errorText: _error,
        onCompleted: _onPinEntered,
      ),
    );
  }
}
