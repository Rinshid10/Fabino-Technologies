import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/features/auth/domain/services/pin_rules.dart';

void main() {
  test('accepts an ordinary six-digit PIN', () {
    expect(PinRules.validate('482913'), isNull);
  });

  test('rejects the wrong length and non-digits', () {
    expect(PinRules.validate('1234'), isNotNull);
    expect(PinRules.validate('12a456'), isNotNull);
  });

  test('rejects a repeated digit', () {
    expect(PinRules.validate('777777'), isNotNull);
  });

  test('rejects ascending and descending sequences', () {
    expect(PinRules.validate('123456'), isNotNull);
    expect(PinRules.validate('987654'), isNotNull);
  });
}
