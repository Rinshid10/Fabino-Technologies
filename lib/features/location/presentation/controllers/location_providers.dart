import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/errors/failures.dart';
import 'package:smart_access_security/features/location/data/geocoding_repository_impl.dart';
import 'package:smart_access_security/features/location/data/geolocator_location_repository.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/domain/services/position_stream_service.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_status_controller.dart';
import 'package:smart_access_security/features/location/presentation/controllers/mock_location_monitor.dart';

part 'location_providers.g.dart';

/// The single owner of the platform position subscription.
@Riverpod(keepAlive: true)
PositionStreamService positionStreamService(Ref ref) {
  final service = PositionStreamService(ref.watch(locationRepositoryProvider));

  // The platform stream dies when GPS is switched off or permission is
  // revoked. Reopen it for the waiting consumers once location is back.
  ref
    ..listen(
      // `null` while the status is still loading, so the first load is
      // not mistaken for location coming back.
      locationStatusControllerProvider.select(
        (status) => status.value?.isReady,
      ),
      (wasReady, isReady) {
        final cameBack = wasReady == false && (isReady ?? false);
        if (cameBack) unawaited(service.restart());
      },
    )
    ..onDispose(service.dispose);
  return service;
}

/// The device's current position.
///
/// Loads one fresh fix, then follows the shared position stream whenever
/// tracking or geofence monitoring has it running.
@riverpod
class CurrentLocation extends _$CurrentLocation {
  @override
  Future<LocationFix> build() async {
    final status = await ref.watch(locationStatusControllerProvider.future);
    if (!status.serviceEnabled) throw const LocationServiceDisabledFailure();
    if (!status.permission.isGranted) {
      throw LocationPermissionFailure(
        permanent: status.permission == LocationPermissionStatus.deniedForever,
      );
    }

    final liveFixes = ref
        .watch(positionStreamServiceProvider)
        .fixes
        .listen((fix) => state = AsyncData(fix), onError: (Object _) {});
    ref.onDispose(liveFixes.cancel);

    final fix = await ref.watch(locationRepositoryProvider).getCurrentFix();
    // A one-off fix does not pass through the shared stream.
    ref.read(mockLocationAlertProvider).check(fix);
    return fix;
  }

  /// Requests a fresh fix, keeping the old one visible while loading.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// The address at the given coordinates, or `null` when unknown.
///
/// Callers should round the coordinates (see [roundForAddress]) so tiny
/// movements do not trigger a new lookup.
@riverpod
Future<String?> address(
  Ref ref, {
  required double latitude,
  required double longitude,
}) {
  return ref
      .watch(geocodingRepositoryProvider)
      .addressFor(latitude: latitude, longitude: longitude);
}

/// Rounds a coordinate to four decimals (about 11 m).
double roundForAddress(double coordinate) {
  return double.parse(coordinate.toStringAsFixed(4));
}
