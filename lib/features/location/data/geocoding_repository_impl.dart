import 'package:geocoding/geocoding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/features/location/domain/repositories/geocoding_repository.dart';

part 'geocoding_repository_impl.g.dart';

/// [GeocodingRepository] using the platform geocoder via `geocoding`.
class GeocodingRepositoryImpl implements GeocodingRepository {
  GeocodingRepositoryImpl() : _geocoding = Geocoding();

  final Geocoding _geocoding;

  @override
  Future<String?> addressFor({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) return null;
      return formatPlacemark(placemarks.first);
    } on Exception {
      // The platform geocoder needs a network connection on most devices;
      // an address is a nice-to-have, never an error.
      return null;
    }
  }

  /// Joins the useful, non-empty, non-repeated parts of [placemark].
  static String? formatPlacemark(Placemark placemark) {
    final parts = <String>[];
    for (final part in [
      placemark.street,
      placemark.subLocality,
      placemark.locality,
      placemark.administrativeArea,
      placemark.postalCode,
      placemark.country,
    ]) {
      final text = part?.trim() ?? '';
      if (text.isNotEmpty && !parts.contains(text)) parts.add(text);
    }
    return parts.isEmpty ? null : parts.join(', ');
  }
}

@Riverpod(keepAlive: true)
GeocodingRepository geocodingRepository(Ref ref) => GeocodingRepositoryImpl();
