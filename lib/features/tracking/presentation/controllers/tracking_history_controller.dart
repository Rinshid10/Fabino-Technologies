import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/features/tracking/data/tracking_repository_impl.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

part 'tracking_history_controller.g.dart';

/// Completed sessions, newest first.
@riverpod
class TrackingHistory extends _$TrackingHistory {
  @override
  Future<List<TrackingSession>> build() async {
    final sessions = await ref.watch(trackingRepositoryProvider).getAll();
    return sessions.where((session) => session.isCompleted).toList();
  }

  Future<void> delete(String id) async {
    await ref.read(trackingRepositoryProvider).delete(id);
    ref.invalidateSelf();
    await future;
  }

  /// Deletes every completed session. A session that is still being
  /// recorded is kept.
  Future<void> clear() async {
    final repository = ref.read(trackingRepositoryProvider);
    final sessions = await repository.getAll();
    for (final session in sessions.where((s) => s.isCompleted)) {
      await repository.delete(session.id);
    }
    ref.invalidateSelf();
    await future;
  }
}

/// One session by id, or `null` when it no longer exists.
@riverpod
Future<TrackingSession?> sessionDetail(Ref ref, String id) {
  // Re-read when the history changes (for example after a delete).
  ref.watch(trackingHistoryProvider);
  return ref.watch(trackingRepositoryProvider).getById(id);
}
