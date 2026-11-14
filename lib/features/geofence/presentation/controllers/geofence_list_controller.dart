import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/features/geofence/data/geofence_repository_impl.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/domain/repositories/geofence_repository.dart';

part 'geofence_list_controller.g.dart';

/// The user's geofences and the actions that change them.
@Riverpod(keepAlive: true)
class GeofenceListController extends _$GeofenceListController {
  GeofenceRepository get _repository => ref.read(geofenceRepositoryProvider);

  @override
  Future<List<Geofence>> build() {
    return ref.watch(geofenceRepositoryProvider).getAll();
  }

  /// Adds a new geofence or replaces the one with the same id.
  Future<void> save(Geofence geofence) async {
    await _repository.save(geofence);
    await _reload();
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    await _reload();
  }

  Future<void> clear() async {
    await _repository.clear();
    await _reload();
  }

  /// Stores the inside / outside states computed by the geofence monitor.
  ///
  /// The in-memory list is updated first, synchronously, so the very next
  /// position is compared against the new states.
  Future<void> applyPresence(List<Geofence> evaluated) async {
    state = AsyncData(evaluated);
    await _repository.saveAll(evaluated);
  }

  Future<void> _reload() async {
    final next = await AsyncValue.guard(_repository.getAll);
    if (ref.mounted) state = next;
  }
}
