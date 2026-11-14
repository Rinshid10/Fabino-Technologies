import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/core/utils/distance.dart';
import 'package:smart_access_security/features/geofence/domain/services/geofence_evaluator.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_list_controller.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_status_controller.dart';

part 'geofence_monitor.g.dart';

@Riverpod(keepAlive: true)
GeofenceEvaluator geofenceEvaluator(Ref ref) {
  return GeofenceEvaluator(ref.watch(distanceCalculatorProvider));
}

/// Watches positions and sends a notification on geofence entry / exit.
///
/// It asks the shared `PositionStreamService` for positions only while
/// there is at least one geofence and location is usable, and it never
/// opens a platform subscription of its own. The root widget watches this
/// provider once so monitoring runs for the app's whole lifetime.
@Riverpod(keepAlive: true)
void geofenceMonitor(Ref ref) {
  final positions = ref.watch(positionStreamServiceProvider);
  final consumer = Object();

  void onFix(LocationFix fix) {
    final geofences = ref.read(geofenceListControllerProvider).value;
    if (geofences == null || geofences.isEmpty) return;

    final evaluation = ref
        .read(geofenceEvaluatorProvider)
        .evaluate(geofences, fix);
    if (evaluation.hasChanges) {
      unawaited(
        ref
            .read(geofenceListControllerProvider.notifier)
            .applyPresence(evaluation.geofences),
      );
    }
    for (final transition in evaluation.transitions) {
      unawaited(_notify(ref.read(notificationServiceProvider), transition));
    }
  }

  /// Holds the position stream only while it is needed.
  void syncSubscription() {
    final hasGeofences =
        ref.read(geofenceListControllerProvider).value?.isNotEmpty ?? false;
    final canLocate =
        ref.read(locationStatusControllerProvider).value?.isReady ?? false;
    unawaited(
      hasGeofences && canLocate
          ? positions.acquire(consumer)
          : positions.release(consumer),
    );
  }

  final fixes = positions.fixes.listen(onFix, onError: (Object _) {});
  ref
    ..listen(
      geofenceListControllerProvider,
      (_, _) => syncSubscription(),
      fireImmediately: true,
    )
    ..listen(locationStatusControllerProvider, (_, _) => syncSubscription())
    ..onDispose(() {
      unawaited(fixes.cancel());
      unawaited(positions.release(consumer));
    });
}

Future<void> _notify(
  NotificationService notifications,
  GeofenceTransition transition,
) {
  final name = transition.geofence.name;
  final (title, body) = switch (transition.type) {
    GeofenceTransitionType.enter => (
      'Entered $name',
      'You are now inside the "$name" geofence.',
    ),
    GeofenceTransitionType.exit => (
      'Left $name',
      'You are now outside the "$name" geofence.',
    ),
  };
  return notifications.show(
    // One notification slot per geofence: a newer event replaces the older.
    id: transition.geofence.id.hashCode & 0x7fffffff,
    channel: NotificationChannel.geofence,
    title: title,
    body: body,
  );
}
