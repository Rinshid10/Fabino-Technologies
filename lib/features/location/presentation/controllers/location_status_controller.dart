import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/features/location/data/geolocator_location_repository.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/domain/repositories/location_repository.dart';

part 'location_status_controller.g.dart';

/// Location permission and GPS on/off, kept up to date.
///
/// It refreshes when the GPS switch changes and whenever the app resumes,
/// because the user may have changed the permission in system settings.
@Riverpod(keepAlive: true)
class LocationStatusController extends _$LocationStatusController {
  LocationRepository get _repository => ref.read(locationRepositoryProvider);

  @override
  Future<LocationStatus> build() async {
    final serviceChanges = ref
        .watch(locationRepositoryProvider)
        .watchServiceEnabled()
        .listen(_onServiceChanged, onError: (Object _) {});
    final lifecycle = AppLifecycleListener(
      onResume: () => unawaited(refresh()),
    );
    ref.onDispose(() {
      unawaited(serviceChanges.cancel());
      lifecycle.dispose();
    });

    return _read();
  }

  Future<void> refresh() async {
    final next = await AsyncValue.guard(_read);
    if (ref.mounted) state = next;
  }

  /// Shows the system permission dialog and returns the new status.
  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await _repository.requestPermission();
    await refresh();
    return permission;
  }

  /// Asks for "allow all the time" so tracking continues in the background.
  Future<LocationPermissionStatus> requestBackgroundPermission() async {
    final permission = await _repository.requestBackgroundPermission();
    await refresh();
    return permission;
  }

  Future<void> openLocationSettings() => _repository.openLocationSettings();

  Future<void> openAppSettings() => _repository.openAppSettings();

  Future<LocationStatus> _read() async {
    return LocationStatus(
      permission: await _repository.checkPermission(),
      serviceEnabled: await _repository.isServiceEnabled(),
    );
  }

  void _onServiceChanged(bool enabled) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(serviceEnabled: enabled));
  }
}
