/// Outcome of checking a PIN.
sealed class PinVerification {
  const PinVerification();
}

/// The PIN was correct.
final class PinAccepted extends PinVerification {
  const PinAccepted();
}

/// The PIN was wrong; [attemptsLeft] tries remain before a lockout.
final class PinRejected extends PinVerification {
  const PinRejected({required this.attemptsLeft});

  final int attemptsLeft;
}

/// PIN entry is blocked until [until] because of repeated failures.
final class PinLockedOut extends PinVerification {
  const PinLockedOut({required this.until});

  final DateTime until;
}
