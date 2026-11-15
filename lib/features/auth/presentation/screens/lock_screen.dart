import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/features/auth/presentation/auth_labels.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/auth_controller.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/pin_entry_view.dart';
import 'package:smart_access_security/features/auth/presentation/widgets/pin_pad.dart';
import 'package:smart_access_security/features/settings/presentation/controllers/settings_controller.dart';

/// Shown whenever the app is locked. Biometrics are offered when enabled;
/// the PIN pad is always available as the fallback.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String? _message;
  DateTime? _lockedUntil;
  bool _isBiometricPromptOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onOpened());
  }

  Future<void> _onOpened() async {
    // Restore a lockout that started before the screen was (re)opened.
    final status = await ref.read(authStatusProvider.future);
    if (!mounted) return;
    setState(() => _lockedUntil = status.lockedUntil);

    if (await _canUseBiometrics()) await _unlockWithBiometrics();
  }

  Future<bool> _canUseBiometrics() async {
    if (!ref.read(settingsControllerProvider).biometricsEnabled) return false;
    final status = await ref.read(biometricStatusProvider.future);
    return status.isAvailable;
  }

  Future<void> _unlockWithBiometrics() async {
    if (_isBiometricPromptOpen || !mounted) return;
    _isBiometricPromptOpen = true;
    final result = await ref
        .read(authControllerProvider)
        .unlockWithBiometrics();
    _isBiometricPromptOpen = false;
    if (mounted && !result.isSuccess) {
      setState(() => _message = result.message);
    }
  }

  Future<void> _unlockWithPin(String pin) async {
    final result = await ref.read(authControllerProvider).unlockWithPin(pin);
    if (!mounted) return;
    setState(() {
      _message = result.errorMessage;
      _lockedUntil = result.lockedUntil;
    });
  }

  @override
  Widget build(BuildContext context) {
    final biometricsEnabled = ref.watch(
      settingsControllerProvider.select((s) => s.biometricsEnabled),
    );
    final biometricsAvailable =
        ref.watch(biometricStatusProvider).value?.isAvailable ?? false;

    return Scaffold(
      body: PinEntryView(
        title: 'Enter your PIN',
        subtitle: 'Smart Access & Location Security is locked.',
        errorText: _message,
        lockedUntil: _lockedUntil,
        onLockoutExpired: () => setState(() {
          _lockedUntil = null;
          _message = null;
        }),
        onCompleted: _unlockWithPin,
        padAction: biometricsEnabled && biometricsAvailable
            ? PinPadActionKey(
                icon: Icons.fingerprint,
                label: 'Biometrics',
                tooltip: 'Unlock with biometrics',
                isAccent: true,
                onPressed: _unlockWithBiometrics,
              )
            : null,
      ),
    );
  }
}
