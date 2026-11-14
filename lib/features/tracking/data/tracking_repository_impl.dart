import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/storage/hive_boxes.dart';
import 'package:smart_access_security/core/storage/json_box_store.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';
import 'package:smart_access_security/features/tracking/domain/repositories/tracking_repository.dart';

part 'tracking_repository_impl.g.dart';

/// [TrackingRepository] that keeps one JSON document per session in Hive.
class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl(Box<String> box)
    : _store = JsonBoxStore(
        box: box,
        fromJson: TrackingSession.fromJson,
        toJson: (session) => session.toJson(),
      );

  final JsonBoxStore<TrackingSession> _store;

  @override
  Future<List<TrackingSession>> getAll() async {
    return _store.readAll()..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  @override
  Future<TrackingSession?> getById(String id) async => _store.read(id);

  @override
  Future<void> save(TrackingSession session) {
    return _store.write(session.id, session);
  }

  @override
  Future<void> delete(String id) => _store.delete(id);

  @override
  Future<void> clear() => _store.clear();
}

@Riverpod(keepAlive: true)
TrackingRepository trackingRepository(Ref ref) {
  return TrackingRepositoryImpl(ref.watch(hiveBoxesProvider).sessions);
}
