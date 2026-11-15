import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';

part 'mock_location_monitor.g.dart';

/// Sends a notification when positions start coming from a mock-location
/// app.
///
/// It alerts once when real positions turn into mocked ones, then stays
/// quiet until a real position has been seen again, so a stream of mocked
/// fixes does not produce a stream of notifications.
class MockLocationAlert {
  MockLocationAlert(this._notifications);

  final NotificationService _notifications;
  bool _wasMocked = false;

  /// Call with every position the app receives.
  void check(LocationFix fix) {
    final startedMocking = fix.isMocked && !_wasMocked;
    _wasMocked = fix.isMocked;
    if (!startedMocking) return;

    unawaited(
      _notifications.show(
        id: NotificationIds.mockLocation,
        channel: NotificationChannel.security,
        title: 'Mock location detected',
        body:
            'Your position is coming from a mock-location app, not from '
            'real GPS.',
      ),
    );
  }
}

@Riverpod(keepAlive: true)
MockLocationAlert mockLocationAlert(Ref ref) {
  return MockLocationAlert(ref.watch(notificationServiceProvider));
}

/// Checks every position of the shared stream for mocking.
///
/// It only listens: it never asks for the stream to be started, so it
/// costs no battery on its own. The root widget watches this provider once
/// so the check runs for the app's whole lifetime.
@Riverpod(keepAlive: true)
void mockLocationMonitor(Ref ref) {
  final alert = ref.watch(mockLocationAlertProvider);
  final fixes = ref
      .watch(positionStreamServiceProvider)
      .fixes
      .listen(alert.check, onError: (Object _) {});
  ref.onDispose(() => unawaited(fixes.cancel()));
}
