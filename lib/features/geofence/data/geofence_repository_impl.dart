import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/storage/hive_boxes.dart';
import 'package:smart_access_security/core/storage/json_box_store.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/domain/repositories/geofence_repository.dart';

part 'geofence_repository_impl.g.dart';

/// [GeofenceRepository] that keeps one JSON document per geofence in Hive.
class GeofenceRepositoryImpl implements GeofenceRepository {
  GeofenceRepositoryImpl(Box<String> box)
    : _store = JsonBoxStore(
        box: box,
        fromJson: Geofence.fromJson,
        toJson: (geofence) => geofence.toJson(),
      );

  final JsonBoxStore<Geofence> _store;

  @override
  Future<List<Geofence>> getAll() async {
    return _store.readAll()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<void> save(Geofence geofence) => _store.write(geofence.id, geofence);

  @override
  Future<void> saveAll(List<Geofence> geofences) {
    return _store.writeAll({
      for (final geofence in geofences) geofence.id: geofence,
    });
  }

  @override
  Future<void> delete(String id) => _store.delete(id);

  @override
  Future<void> clear() => _store.clear();
}

@Riverpod(keepAlive: true)
GeofenceRepository geofenceRepository(Ref ref) {
  return GeofenceRepositoryImpl(ref.watch(hiveBoxesProvider).geofences);
}
