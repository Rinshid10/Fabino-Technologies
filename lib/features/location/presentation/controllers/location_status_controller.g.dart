// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Location permission and GPS on/off, kept up to date.
///
/// It refreshes when the GPS switch changes and whenever the app resumes,
/// because the user may have changed the permission in system settings.

@ProviderFor(LocationStatusController)
final locationStatusControllerProvider = LocationStatusControllerProvider._();

/// Location permission and GPS on/off, kept up to date.
///
/// It refreshes when the GPS switch changes and whenever the app resumes,
/// because the user may have changed the permission in system settings.
final class LocationStatusControllerProvider
    extends $AsyncNotifierProvider<LocationStatusController, LocationStatus> {
  /// Location permission and GPS on/off, kept up to date.
  ///
  /// It refreshes when the GPS switch changes and whenever the app resumes,
  /// because the user may have changed the permission in system settings.
  LocationStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationStatusControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationStatusControllerHash();

  @$internal
  @override
  LocationStatusController create() => LocationStatusController();
}

String _$locationStatusControllerHash() =>
    r'f9cbb49b3e680ac2c85c82d33350d67d6d2a8c96';

/// Location permission and GPS on/off, kept up to date.
///
/// It refreshes when the GPS switch changes and whenever the app resumes,
/// because the user may have changed the permission in system settings.

abstract class _$LocationStatusController
    extends $AsyncNotifier<LocationStatus> {
  FutureOr<LocationStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LocationStatus>, LocationStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LocationStatus>, LocationStatus>,
              AsyncValue<LocationStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
