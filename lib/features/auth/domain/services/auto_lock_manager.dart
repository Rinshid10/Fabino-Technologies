import 'dart:async';

import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/features/auth/domain/services/auto_lock_policy.dart';
import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';

/// Tracks background time and in-app inactivity and calls the lock
/// callback when the [AutoLockPolicy] says the app must lock.
///
/// It knows nothing about Flutter: the app feeds it lifecycle and touch
/// events, which keeps the timing rules unit-testable.
class AutoLockManager {
  AutoLockManager({
    required Clock clock,
    required AutoLockDuration Function() readSetting,
    required bool Function() isUnlocked,
    required void Function() onLock,
    AutoLockPolicy policy = const AutoLockPolicy(),
  }) : _clock = clock,
       _readSetting = readSetting,
       _isUnlocked = isUnlocked,
       _onLock = onLock,
       _policy = policy;

  final Clock _clock;
  final AutoLockDuration Function() _readSetting;
  final bool Function() _isUnlocked;
  final void Function() _onLock;
  final AutoLockPolicy _policy;

  DateTime? _backgroundedAt;
  Timer? _inactivityTimer;

  /// The app is no longer visible.
  void onBackgrounded() {
    _inactivityTimer?.cancel();
    // Time away only matters if there is an unlocked session to protect.
    _backgroundedAt = _isUnlocked() ? _clock() : null;
  }

  /// The app is visible again.
  void onForegrounded() {
    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;
    if (backgroundedAt == null) return;

    final timeAway = _clock().difference(backgroundedAt);
    if (_policy.shouldLockAfterBackground(_readSetting(), timeAway)) {
      _onLock();
    } else {
      restartInactivityTimer();
    }
  }

  /// The user touched the screen.
  void onUserActivity() => restartInactivityTimer();

  /// (Re)starts the idle countdown. Call when the lock state or the
  /// auto-lock setting changes.
  void restartInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    if (!_isUnlocked()) return;

    final timeout = _policy.inactivityTimeout(_readSetting());
    if (timeout == null) return;
    _inactivityTimer = Timer(timeout, _onLock);
  }

  void dispose() => _inactivityTimer?.cancel();
}
