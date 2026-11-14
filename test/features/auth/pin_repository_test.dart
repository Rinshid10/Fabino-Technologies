import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/features/auth/data/pbkdf2_pin_hasher.dart';
import 'package:smart_access_security/features/auth/data/pin_repository_impl.dart';

import '../../helpers/fakes.dart';

void main() {
  late InMemorySecureStore store;
  late PinRepositoryImpl repository;

  setUp(() {
    store = InMemorySecureStore();
    repository = PinRepositoryImpl(
      store: store,
      // Few iterations keep the test fast; the algorithm is the real one.
      hasher: Pbkdf2PinHasher(iterations: 10),
    );
  });

  test('hasPin is false until a PIN is saved, and false after clear', () async {
    expect(await repository.hasPin(), isFalse);

    await repository.savePin('482913');
    expect(await repository.hasPin(), isTrue);

    await repository.clear();
    expect(await repository.hasPin(), isFalse);
  });

  test('matches only the saved PIN', () async {
    await repository.savePin('482913');

    expect(await repository.matches('482913'), isTrue);
    expect(await repository.matches('482914'), isFalse);
  });

  test('matches is false when no PIN exists', () async {
    expect(await repository.matches('482913'), isFalse);
  });

  test('the PIN itself is never written to storage', () async {
    await repository.savePin('482913');

    final stored = store.values[StorageKeys.pinCredential]!;
    expect(stored, isNot(contains('482913')));
    expect(stored, contains('salt'));
  });

  test('the same PIN gets a different salt and hash each time', () async {
    await repository.savePin('482913');
    final first = store.values[StorageKeys.pinCredential];

    await repository.savePin('482913');
    final second = store.values[StorageKeys.pinCredential];

    expect(first, isNot(second));
    expect(await repository.matches('482913'), isTrue);
  });
}
