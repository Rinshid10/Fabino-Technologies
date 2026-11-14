import 'dart:async';

import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/domain/repositories/location_repository.dart';

/// Owns the app's one and only platform position subscription.
///
/// Features never listen to the location plugin directly. They call
/// [acquire] to say "I need positions", listen to [fixes], and call
/// [release] when done. The platform stream runs while at least one
/// consumer holds it and is shared by all of them, so re-entering screens
/// or lifecycle changes can never create a second subscription.
class PositionStreamService {
  PositionStreamService(this._repository);

  final LocationRepository _repository;
  final _fixes = StreamController<LocationFix>.broadcast();

  /// Each consumer and whether it needs background updates.
  final Map<Object, bool> _consumers = {};

  StreamSubscription<LocationFix>? _subscription;
  bool _isBackground = false;
  bool _isDisposed = false;
  LocationFix? _lastFix;

  /// Start / stop requests run one after another, so a new subscription is
  /// never opened before the previous one has been cancelled.
  Future<void> _pending = Future.value();

  /// Positions for every consumer. Errors (GPS off, permission revoked)
  /// arrive as stream errors.
  Stream<LocationFix> get fixes => _fixes.stream;

  /// The most recent position, if any arrived since the stream started.
  LocationFix? get lastFix => _lastFix;

  /// Whether the platform subscription is currently open.
  bool get isActive => _subscription != null;

  /// Registers [consumer]. Calling it again for the same consumer only
  /// updates its [background] need.
  Future<void> acquire(Object consumer, {bool background = false}) {
    _consumers[consumer] = background;
    return _sync();
  }

  Future<void> release(Object consumer) {
    _consumers.remove(consumer);
    return _sync();
  }

  /// Reopens the platform stream, for example after GPS was switched back
  /// on. Does nothing when there are no consumers.
  Future<void> restart() => _sync(force: true);

  Future<void> dispose() async {
    _isDisposed = true;
    _consumers.clear();
    await _sync();
    await _fixes.close();
  }

  Future<void> _sync({bool force = false}) {
    return _pending = _pending.then((_) => _apply(force: force));
  }

  Future<void> _apply({required bool force}) async {
    final isNeeded = _consumers.isNotEmpty;
    final needsBackground = _consumers.containsValue(true);
    final isUpToDate =
        isNeeded == isActive && (!isNeeded || needsBackground == _isBackground);
    if (isUpToDate && !force) return;

    await _subscription?.cancel();
    _subscription = null;
    if (!isNeeded) return;

    _isBackground = needsBackground;
    _subscription = _repository
        .watchPosition(background: needsBackground)
        .listen(_onFix, onError: _onError);
  }

  void _onFix(LocationFix fix) {
    _lastFix = fix;
    if (!_isDisposed) _fixes.add(fix);
  }

  void _onError(Object error, StackTrace stackTrace) {
    if (!_isDisposed) _fixes.addError(error, stackTrace);
  }
}
