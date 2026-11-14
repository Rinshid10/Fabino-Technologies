/// Stores and checks the app PIN. The PIN itself is never persisted.
abstract interface class PinRepository {
  Future<bool> hasPin();

  /// Replaces the stored PIN with [pin].
  Future<void> savePin(String pin);

  /// Whether [pin] matches the stored PIN.
  Future<bool> matches(String pin);

  Future<void> clear();
}
