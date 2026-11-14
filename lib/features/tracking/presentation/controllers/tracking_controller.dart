import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/core/utils/distance.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/tracking/data/tracking_repository_impl.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';
import 'package:smart_access_security/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:smart_access_security/features/tracking/domain/services/tracking_calculator.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';
import 'package:uuid/uuid.dart';

part 'tracking_controller.freezed.dart';
part 'tracking_controller.g.dart';

/// What the tracking screen shows.
@freezed
abstract class TrackingState with _$TrackingState {
  const factory TrackingState({
    /// The session being recorded, or `null` when idle.
    TrackingSession? session,

    /// Metres per second.
    @Default(0) double currentSpeed,
    LocationFix? lastFix,

    /// `start()` is in progress.
    @Default(false) bool isStarting,
  }) = _TrackingState;

  const TrackingState._();

  bool get isTracking => session != null;
}

@Riverpod(keepAlive: true)
TrackingCalculator trackingCalculator(Ref ref) {
  return TrackingCalculator(ref.watch(distanceCalculatorProvider));
}

/// Starts and stops tracking sessions and builds the live route.
///
/// It is kept alive for the whole app run, so a session continues while
/// the user visits other screens, the app is locked or minimised. It gets
/// positions from the shared `PositionStreamService` and never opens a
/// platform subscription itself.
@Riverpod(keepAlive: true)
class TrackingController extends _$TrackingController {
  /// Save the running session after this many new points, so little is
  /// lost if the app is killed.
  static const _autosaveEvery = 10;

  StreamSubscription<LocationFix>? _fixes;

  TrackingRepository get _repository => ref.read(trackingRepositoryProvider);

  @override
  TrackingState build() {
    ref.onDispose(() => unawaited(_fixes?.cancel()));
    unawaited(_finishInterruptedSessions());
    return const TrackingState();
  }

  Future<void> start() async {
    if (state.isTracking || state.isStarting) return;
    state = state.copyWith(isStarting: true);

    final notifications = ref.read(notificationServiceProvider);
    await notifications.requestPermission();

    final session = TrackingSession(
      id: const Uuid().v4(),
      startedAt: ref.read(clockProvider)(),
    );
    await _repository.save(session);

    final positions = ref.read(positionStreamServiceProvider);
    _fixes = positions.fixes.listen(_onFix, onError: (Object _) {});
    await positions.acquire(this, background: true);

    state = TrackingState(session: session);
    await notifications.show(
      id: NotificationIds.tracking,
      channel: NotificationChannel.tracking,
      title: 'Tracking started',
      body: 'Your route is being recorded.',
    );
  }

  /// Ends the session, saves it and returns it.
  Future<TrackingSession?> stop() async {
    final session = state.session;
    if (session == null) return null;
    state = const TrackingState();

    await _fixes?.cancel();
    _fixes = null;
    await ref.read(positionStreamServiceProvider).release(this);

    final completed = session.copyWith(endedAt: ref.read(clockProvider)());
    await _repository.save(completed);
    ref.invalidate(trackingHistoryProvider);

    await ref
        .read(notificationServiceProvider)
        .show(
          id: NotificationIds.tracking,
          channel: NotificationChannel.tracking,
          title: 'Tracking stopped',
          body:
              '${Formatters.distance(completed.distanceMeters)} in '
              '${Formatters.duration(completed.duration)}.',
        );
    return completed;
  }

  void _onFix(LocationFix fix) {
    final session = state.session;
    if (session == null) return;

    final calculator = ref.read(trackingCalculatorProvider);
    final updated = calculator.addFix(session, fix);
    state = state.copyWith(
      session: updated,
      currentSpeed: calculator.currentSpeed(session.points.lastOrNull, fix),
      lastFix: fix,
    );

    final grew = updated.points.length != session.points.length;
    if (grew && updated.points.length % _autosaveEvery == 0) {
      unawaited(_repository.save(updated));
    }
  }

  /// A session without an end time at start-up means the app was killed
  /// while tracking. Close it at its last recorded point so it shows up
  /// in the history instead of being lost.
  Future<void> _finishInterruptedSessions() async {
    final sessions = await _repository.getAll();
    var recovered = false;
    for (final session in sessions.where((s) => !s.isCompleted)) {
      if (session.id == state.session?.id) continue;
      await _repository.save(
        session.copyWith(endedAt: session.startedAt.add(session.duration)),
      );
      recovered = true;
    }
    if (recovered && ref.mounted) ref.invalidate(trackingHistoryProvider);
  }
}
