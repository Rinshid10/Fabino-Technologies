// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geofenceRepository)
final geofenceRepositoryProvider = GeofenceRepositoryProvider._();

final class GeofenceRepositoryProvider
    extends
        $FunctionalProvider<
          GeofenceRepository,
          GeofenceRepository,
          GeofenceRepository
        >
    with $Provider<GeofenceRepository> {
  GeofenceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geofenceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geofenceRepositoryHash();

  @$internal
  @override
  $ProviderElement<GeofenceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeofenceRepository create(Ref ref) {
    return geofenceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeofenceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeofenceRepository>(value),
    );
  }
}

String _$geofenceRepositoryHash() =>
    r'e790ec523ebc28aebc4c2dbac5350c5342e7df97';
