import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';

/// Decides when the app must lock itself.
class AutoLockPolicy {
  const AutoLockPolicy({
    this.minimumInactivityTimeout = const Duration(minutes: 1),
  });

  /// Idle timeout used when the setting is "immediately", which only makes
  /// sense for leaving the app, not for pausing between taps.
  final Duration minimumInactivityTimeout;

  /// Whether to lock after the app spent [timeAway] in the background.
  bool shouldLockAfterBackground(AutoLockDuration setting, Duration timeAway) {
    final timeout = setting.timeout;
    return timeout != null && timeAway >= timeout;
  }

  /// How long the user may be idle in the app, or `null` for no limit.
  Duration? inactivityTimeout(AutoLockDuration setting) {
    final timeout = setting.timeout;
    if (timeout == null) return null;
    return timeout < minimumInactivityTimeout
        ? minimumInactivityTimeout
        : timeout;
  }
}
