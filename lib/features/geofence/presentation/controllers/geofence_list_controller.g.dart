// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The user's geofences and the actions that change them.

@ProviderFor(GeofenceListController)
final geofenceListControllerProvider = GeofenceListControllerProvider._();

/// The user's geofences and the actions that change them.
final class GeofenceListControllerProvider
    extends $AsyncNotifierProvider<GeofenceListController, List<Geofence>> {
  /// The user's geofences and the actions that change them.
  GeofenceListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geofenceListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geofenceListControllerHash();

  @$internal
  @override
  GeofenceListController create() => GeofenceListController();
}

String _$geofenceListControllerHash() =>
    r'a2c0d1944ad70d0850b43db2a438dbe919e37703';

/// The user's geofences and the actions that change them.

abstract class _$GeofenceListController extends $AsyncNotifier<List<Geofence>> {
  FutureOr<List<Geofence>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Geofence>>, List<Geofence>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Geofence>>, List<Geofence>>,
              AsyncValue<List<Geofence>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
