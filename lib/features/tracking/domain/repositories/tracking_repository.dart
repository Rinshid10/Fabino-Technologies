import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

/// Local storage for tracking sessions.
abstract interface class TrackingRepository {
  /// All sessions, newest first.
  Future<List<TrackingSession>> getAll();

  Future<TrackingSession?> getById(String id);

  /// Inserts or replaces the session with the same id.
  Future<void> save(TrackingSession session);

  Future<void> delete(String id);

  Future<void> clear();
}
