import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/features/auth/data/auth_status_repository_impl.dart';
import 'package:smart_access_security/features/auth/data/pin_repository_impl.dart';
import 'package:smart_access_security/features/auth/domain/entities/pin_verification.dart';
import 'package:smart_access_security/features/auth/domain/services/auth_service.dart';

import '../../helpers/fakes.dart';

void main() {
  late DateTime now;
  late AuthService service;

  setUp(() async {
    now = DateTime(2026, 11, 14, 9);
    final store = InMemorySecureStore();
    service = AuthService(
      pinRepository: PinRepositoryImpl(store: store, hasher: FakePinHasher()),
      statusRepository: AuthStatusRepositoryImpl(store),
      clock: () => now,
    );
    await service.setPin('482913');
  });

  test('setting a PIN counts as a successful authentication', () async {
    expect((await service.status()).lastSuccessfulAuthAt, now);
  });

  test('the correct PIN is accepted and updates the last auth time', () async {
    now = now.add(const Duration(hours: 1));

    expect(await service.verifyPin('482913'), isA<PinAccepted>());
    expect((await service.status()).lastSuccessfulAuthAt, now);
  });

  test('a wrong PIN is rejected and counts down the attempts', () async {
    final result = await service.verifyPin('000001');

    expect(result, isA<PinRejected>());
    expect((result as PinRejected).attemptsLeft, 4);
  });

  test('five wrong PINs lock out even the correct PIN', () async {
    PinVerification? result;
    for (var i = 0; i < 5; i++) {
      result = await service.verifyPin('000001');
    }
    expect(result, isA<PinLockedOut>());

    final whileLocked = await service.verifyPin('482913');
    expect(whileLocked, isA<PinLockedOut>());
    expect(
      (whileLocked as PinLockedOut).until,
      now.add(const Duration(seconds: 30)),
    );
  });

  test('the correct PIN works again after the lockout ends', () async {
    for (var i = 0; i < 5; i++) {
      await service.verifyPin('000001');
    }
    now = now.add(const Duration(seconds: 31));

    expect(await service.verifyPin('482913'), isA<PinAccepted>());
    expect((await service.status()).failedAttempts, 0);
  });
}
