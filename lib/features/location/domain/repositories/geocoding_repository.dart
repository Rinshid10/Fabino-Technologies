/// Turns coordinates into a human-readable address.
// An interface (not a function type) keeps the data source swappable and
// mockable like every other repository.
// ignore: one_member_abstracts
abstract interface class GeocodingRepository {
  /// Returns the address at the coordinates, or `null` when none is found
  /// (for example without a network connection).
  Future<String?> addressFor({
    required double latitude,
    required double longitude,
  });
}
