// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_monitor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geofenceEvaluator)
final geofenceEvaluatorProvider = GeofenceEvaluatorProvider._();

final class GeofenceEvaluatorProvider
    extends
        $FunctionalProvider<
          GeofenceEvaluator,
          GeofenceEvaluator,
          GeofenceEvaluator
        >
    with $Provider<GeofenceEvaluator> {
  GeofenceEvaluatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geofenceEvaluatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geofenceEvaluatorHash();

  @$internal
  @override
  $ProviderElement<GeofenceEvaluator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeofenceEvaluator create(Ref ref) {
    return geofenceEvaluator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeofenceEvaluator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeofenceEvaluator>(value),
    );
  }
}

String _$geofenceEvaluatorHash() => r'361dca187c1fdbe8794d6218fdb0c28e1d5ff5e6';

/// Watches positions and sends a notification on geofence entry / exit.
///
/// It asks the shared `PositionStreamService` for positions only while
/// there is at least one geofence and location is usable, and it never
/// opens a platform subscription of its own. The root widget watches this
/// provider once so monitoring runs for the app's whole lifetime.

@ProviderFor(geofenceMonitor)
final geofenceMonitorProvider = GeofenceMonitorProvider._();

/// Watches positions and sends a notification on geofence entry / exit.
///
/// It asks the shared `PositionStreamService` for positions only while
/// there is at least one geofence and location is usable, and it never
/// opens a platform subscription of its own. The root widget watches this
/// provider once so monitoring runs for the app's whole lifetime.

final class GeofenceMonitorProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Watches positions and sends a notification on geofence entry / exit.
  ///
  /// It asks the shared `PositionStreamService` for positions only while
  /// there is at least one geofence and location is usable, and it never
  /// opens a platform subscription of its own. The root widget watches this
  /// provider once so monitoring runs for the app's whole lifetime.
  GeofenceMonitorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geofenceMonitorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geofenceMonitorHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return geofenceMonitor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$geofenceMonitorHash() => r'fbba9f629678583e32920376415fdd09caa2bab7';
