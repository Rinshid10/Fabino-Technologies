import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/errors/failures.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/domain/repositories/location_repository.dart';

part 'geolocator_location_repository.g.dart';

/// [LocationRepository] backed by `geolocator`.
class GeolocatorLocationRepository implements LocationRepository {
  const GeolocatorLocationRepository();

  static const LocationAccuracy _accuracy = LocationAccuracy.high;

  /// Minimum movement, in metres, before a new position is delivered.
  static const _distanceFilter = 5;
  static const _currentFixTimeout = Duration(seconds: 20);

  @override
  Future<LocationPermissionStatus> checkPermission() async {
    return _toStatus(await Geolocator.checkPermission());
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    return _toStatus(await Geolocator.requestPermission());
  }

  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Stream<bool> watchServiceEnabled() {
    return Geolocator.getServiceStatusStream().map(
      (status) => status == ServiceStatus.enabled,
    );
  }

  @override
  Future<LocationFix> getCurrentFix() async {
    if (!await isServiceEnabled()) {
      throw const LocationServiceDisabledFailure();
    }
    final permission = await checkPermission();
    if (!permission.isGranted) {
      throw LocationPermissionFailure(
        permanent: permission == LocationPermissionStatus.deniedForever,
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: _accuracy,
          timeLimit: _currentFixTimeout,
        ),
      );
      return _toFix(position);
    } on TimeoutException {
      // No fresh fix in time (indoors, cold start): fall back to the last
      // position the device knows rather than showing nothing.
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown == null) throw const LocationUnavailableFailure();
      return _toFix(lastKnown);
    } on Exception catch (error) {
      throw _toFailure(error);
    }
  }

  @override
  Stream<LocationFix> watchPosition({required bool background}) {
    return Geolocator.getPositionStream(
      locationSettings: _streamSettings(background: background),
    ).transform(
      StreamTransformer.fromHandlers(
        handleData: (position, sink) => sink.add(_toFix(position)),
        handleError: (error, stackTrace, sink) =>
            sink.addError(_toFailure(error), stackTrace),
      ),
    );
  }

  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  static LocationSettings _streamSettings({required bool background}) {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidSettings(
        accuracy: _accuracy,
        distanceFilter: _distanceFilter,
        intervalDuration: const Duration(seconds: 3),
        // A foreground service with an ongoing notification keeps updates
        // coming while the app is minimised.
        foregroundNotificationConfig: background
            ? const ForegroundNotificationConfig(
                notificationTitle: 'Tracking in progress',
                notificationText: 'Your route is being recorded.',
                notificationChannelName: 'Background tracking',
                enableWakeLock: true,
                setOngoing: true,
              )
            : null,
      ),
      TargetPlatform.iOS => AppleSettings(
        accuracy: _accuracy,
        distanceFilter: _distanceFilter,
        activityType: ActivityType.fitness,
        allowBackgroundLocationUpdates: background,
        showBackgroundLocationIndicator: background,
      ),
      _ => const LocationSettings(
        accuracy: _accuracy,
        distanceFilter: _distanceFilter,
      ),
    };
  }

  static LocationFix _toFix(Position position) {
    final speed = position.speed;
    return LocationFix(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      // Platforms report -1 or NaN when the speed is unknown.
      speed: speed.isFinite && speed > 0 ? speed : 0,
      timestamp: position.timestamp,
      isMocked: position.isMocked,
    );
  }

  static LocationPermissionStatus _toStatus(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.denied ||
      LocationPermission.unableToDetermine => LocationPermissionStatus.denied,
      LocationPermission.deniedForever =>
        LocationPermissionStatus.deniedForever,
      LocationPermission.whileInUse => LocationPermissionStatus.whileInUse,
      LocationPermission.always => LocationPermissionStatus.always,
    };
  }

  static Failure _toFailure(Object error) => switch (error) {
    Failure() => error,
    LocationServiceDisabledException() =>
      const LocationServiceDisabledFailure(),
    PermissionDeniedException() => const LocationPermissionFailure(),
    _ => const LocationUnavailableFailure(),
  };
}

@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) {
  return const GeolocatorLocationRepository();
}
