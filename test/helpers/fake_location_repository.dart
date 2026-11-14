import 'dart:async';

import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/domain/repositories/location_repository.dart';

/// Builds a [LocationFix] with sensible defaults for tests.
LocationFix fixAt(
  double latitude,
  double longitude, {
  DateTime? timestamp,
  double accuracy = 5,
  double speed = 0,
  bool isMocked = false,
}) {
  return LocationFix(
    latitude: latitude,
    longitude: longitude,
    accuracy: accuracy,
    speed: speed,
    timestamp: timestamp ?? DateTime(2026, 11, 14, 10),
    isMocked: isMocked,
  );
}

/// [LocationRepository] whose position stream the test drives by hand and
/// which records how many platform subscriptions are open.
class FakeLocationRepository implements LocationRepository {
  LocationPermissionStatus permission = LocationPermissionStatus.whileInUse;
  bool serviceEnabled = true;
  LocationFix currentFix = fixAt(10, 20);

  /// Subscriptions currently open on the position stream.
  int activeSubscriptions = 0;

  /// The highest number of subscriptions that were ever open at once.
  int maxConcurrentSubscriptions = 0;

  /// The `background` flag of every stream opened so far.
  final List<bool> openedWithBackground = [];

  StreamController<LocationFix>? _positions;

  /// Delivers [fix] to the open position stream.
  void emit(LocationFix fix) => _positions?.add(fix);

  void emitError(Object error) => _positions?.addError(error);

  @override
  Stream<LocationFix> watchPosition({required bool background}) {
    openedWithBackground.add(background);
    final controller = StreamController<LocationFix>(
      onListen: () {
        activeSubscriptions++;
        if (activeSubscriptions > maxConcurrentSubscriptions) {
          maxConcurrentSubscriptions = activeSubscriptions;
        }
      },
      onCancel: () => activeSubscriptions--,
    );
    _positions = controller;
    return controller.stream;
  }

  @override
  Future<LocationPermissionStatus> checkPermission() async => permission;

  @override
  Future<LocationPermissionStatus> requestPermission() async => permission;

  @override
  Future<bool> isServiceEnabled() async => serviceEnabled;

  @override
  Stream<bool> watchServiceEnabled() => const Stream.empty();

  @override
  Future<LocationFix> getCurrentFix() async => currentFix;

  @override
  Future<void> openLocationSettings() async {}

  @override
  Future<void> openAppSettings() async {}
}
