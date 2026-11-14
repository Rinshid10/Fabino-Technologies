import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';

/// Local storage for geofences.
abstract interface class GeofenceRepository {
  /// All geofences, oldest first.
  Future<List<Geofence>> getAll();

  /// Inserts or replaces the geofence with the same id.
  Future<void> save(Geofence geofence);

  /// Inserts or replaces several geofences at once.
  Future<void> saveAll(List<Geofence> geofences);

  Future<void> delete(String id);

  Future<void> clear();
}
