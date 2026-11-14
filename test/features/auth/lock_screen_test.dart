import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/core/storage/secure_store.dart';
import 'package:smart_access_security/features/auth/data/local_auth_biometric_repository.dart';
import 'package:smart_access_security/features/auth/data/pin_repository_impl.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_result.dart';
import 'package:smart_access_security/features/auth/domain/entities/biometric_status.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';
import 'package:smart_access_security/features/auth/presentation/screens/lock_screen.dart';
import 'package:smart_access_security/features/settings/data/settings_repository_impl.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';
import 'package:smart_access_security/features/settings/domain/repositories/settings_repository.dart';

import '../../helpers/fakes.dart';

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this._settings);

  AppSettings _settings;

  @override
  AppSettings load() => _settings;

  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

void main() {
  const correctPin = '482913';
  late FakeBiometricRepository biometrics;

  Future<ProviderContainer> pumpLockScreen(
    WidgetTester tester, {
    bool biometricsEnabled = false,
  }) async {
    final store = InMemorySecureStore();
    final container = ProviderContainer(
      overrides: [
        secureStoreProvider.overrideWithValue(store),
        pinHasherProvider.overrideWithValue(FakePinHasher()),
        biometricRepositoryProvider.overrideWithValue(biometrics),
        pinConfiguredAtStartupProvider.overrideWithValue(true),
        settingsRepositoryProvider.overrideWithValue(
          _FakeSettingsRepository(
            AppSettings(biometricsEnabled: biometricsEnabled),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(pinRepositoryProvider).savePin(correctPin);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LockScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> enterPin(WidgetTester tester, String pin) async {
    for (final digit in pin.split('')) {
      await tester.tap(find.byKey(ValueKey('pin-key-$digit')));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  setUp(() => biometrics = FakeBiometricRepository());

  testWidgets('the correct PIN unlocks the app', (tester) async {
    final container = await pumpLockScreen(tester);
    expect(container.read(appLockProvider), AppLockState.locked);

    await enterPin(tester, correctPin);

    expect(container.read(appLockProvider), AppLockState.unlocked);
  });

  testWidgets('a wrong PIN shows the attempts left and stays locked', (
    tester,
  ) async {
    final container = await pumpLockScreen(tester);

    await enterPin(tester, '111112');

    expect(find.textContaining('4 attempts left'), findsOneWidget);
    expect(container.read(appLockProvider), AppLockState.locked);
  });

  testWidgets('no biometric button when biometrics are disabled', (
    tester,
  ) async {
    biometrics.status = const BiometricStatus(
      isSupported: true,
      enrolled: [BiometricKind.fingerprint],
    );
    await pumpLockScreen(tester);

    expect(find.byIcon(Icons.fingerprint), findsNothing);
    expect(biometrics.promptCount, 0);
  });

  testWidgets('prompts for biometrics on open and unlocks on success', (
    tester,
  ) async {
    biometrics
      ..status = const BiometricStatus(
        isSupported: true,
        enrolled: [BiometricKind.fingerprint],
      )
      ..result = BiometricResult.success;

    final container = await pumpLockScreen(tester, biometricsEnabled: true);

    expect(biometrics.promptCount, 1);
    expect(container.read(appLockProvider), AppLockState.unlocked);
  });

  testWidgets('a cancelled biometric prompt falls back to the PIN', (
    tester,
  ) async {
    biometrics
      ..status = const BiometricStatus(
        isSupported: true,
        enrolled: [BiometricKind.face],
      )
      ..result = BiometricResult.cancelled;

    final container = await pumpLockScreen(tester, biometricsEnabled: true);

    expect(find.textContaining('Enter your PIN.'), findsOneWidget);
    expect(container.read(appLockProvider), AppLockState.locked);

    await enterPin(tester, correctPin);
    expect(container.read(appLockProvider), AppLockState.unlocked);
  });

  testWidgets('a biometric lockout is explained and the PIN still works', (
    tester,
  ) async {
    biometrics
      ..status = const BiometricStatus(
        isSupported: true,
        enrolled: [BiometricKind.fingerprint],
      )
      ..result = BiometricResult.lockedOut;

    await pumpLockScreen(tester, biometricsEnabled: true);

    expect(find.textContaining('Too many biometric attempts'), findsOneWidget);
    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
  });
}
