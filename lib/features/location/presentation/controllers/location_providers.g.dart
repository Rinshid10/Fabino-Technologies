// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single owner of the platform position subscription.

@ProviderFor(positionStreamService)
final positionStreamServiceProvider = PositionStreamServiceProvider._();

/// The single owner of the platform position subscription.

final class PositionStreamServiceProvider
    extends
        $FunctionalProvider<
          PositionStreamService,
          PositionStreamService,
          PositionStreamService
        >
    with $Provider<PositionStreamService> {
  /// The single owner of the platform position subscription.
  PositionStreamServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'positionStreamServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$positionStreamServiceHash();

  @$internal
  @override
  $ProviderElement<PositionStreamService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PositionStreamService create(Ref ref) {
    return positionStreamService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PositionStreamService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PositionStreamService>(value),
    );
  }
}

String _$positionStreamServiceHash() =>
    r'8c807357fa2ba06be7690315d8dec14e6fb49442';

/// The device's current position.
///
/// Loads one fresh fix, then follows the shared position stream whenever
/// tracking or geofence monitoring has it running.

@ProviderFor(CurrentLocation)
final currentLocationProvider = CurrentLocationProvider._();

/// The device's current position.
///
/// Loads one fresh fix, then follows the shared position stream whenever
/// tracking or geofence monitoring has it running.
final class CurrentLocationProvider
    extends $AsyncNotifierProvider<CurrentLocation, LocationFix> {
  /// The device's current position.
  ///
  /// Loads one fresh fix, then follows the shared position stream whenever
  /// tracking or geofence monitoring has it running.
  CurrentLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocationHash();

  @$internal
  @override
  CurrentLocation create() => CurrentLocation();
}

String _$currentLocationHash() => r'bd625e1b8d8744e00150f9a5c2d2bfd1f2154a43';

/// The device's current position.
///
/// Loads one fresh fix, then follows the shared position stream whenever
/// tracking or geofence monitoring has it running.

abstract class _$CurrentLocation extends $AsyncNotifier<LocationFix> {
  FutureOr<LocationFix> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LocationFix>, LocationFix>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LocationFix>, LocationFix>,
              AsyncValue<LocationFix>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The address at the given coordinates, or `null` when unknown.
///
/// Callers should round the coordinates (see [roundForAddress]) so tiny
/// movements do not trigger a new lookup.

@ProviderFor(address)
final addressProvider = AddressFamily._();

/// The address at the given coordinates, or `null` when unknown.
///
/// Callers should round the coordinates (see [roundForAddress]) so tiny
/// movements do not trigger a new lookup.

final class AddressProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The address at the given coordinates, or `null` when unknown.
  ///
  /// Callers should round the coordinates (see [roundForAddress]) so tiny
  /// movements do not trigger a new lookup.
  AddressProvider._({
    required AddressFamily super.from,
    required ({double latitude, double longitude}) super.argument,
  }) : super(
         retry: null,
         name: r'addressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addressHash();

  @override
  String toString() {
    return r'addressProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as ({double latitude, double longitude});
    return address(
      ref,
      latitude: argument.latitude,
      longitude: argument.longitude,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addressHash() => r'80f389a7a27a36787583c0065781914d9a3bc7d9';

/// The address at the given coordinates, or `null` when unknown.
///
/// Callers should round the coordinates (see [roundForAddress]) so tiny
/// movements do not trigger a new lookup.

final class AddressFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String?>,
          ({double latitude, double longitude})
        > {
  AddressFamily._()
    : super(
        retry: null,
        name: r'addressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The address at the given coordinates, or `null` when unknown.
  ///
  /// Callers should round the coordinates (see [roundForAddress]) so tiny
  /// movements do not trigger a new lookup.

  AddressProvider call({required double latitude, required double longitude}) =>
      AddressProvider._(
        argument: (latitude: latitude, longitude: longitude),
        from: this,
      );

  @override
  String toString() => r'addressProvider';
}
