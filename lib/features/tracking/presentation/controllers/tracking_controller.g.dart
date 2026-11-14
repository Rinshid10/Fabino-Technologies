// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trackingCalculator)
final trackingCalculatorProvider = TrackingCalculatorProvider._();

final class TrackingCalculatorProvider
    extends
        $FunctionalProvider<
          TrackingCalculator,
          TrackingCalculator,
          TrackingCalculator
        >
    with $Provider<TrackingCalculator> {
  TrackingCalculatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackingCalculatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackingCalculatorHash();

  @$internal
  @override
  $ProviderElement<TrackingCalculator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrackingCalculator create(Ref ref) {
    return trackingCalculator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackingCalculator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackingCalculator>(value),
    );
  }
}

String _$trackingCalculatorHash() =>
    r'3ce316060fd2d0e21313134805eb867833dd6271';

/// Starts and stops tracking sessions and builds the live route.
///
/// It is kept alive for the whole app run, so a session continues while
/// the user visits other screens, the app is locked or minimised. It gets
/// positions from the shared `PositionStreamService` and never opens a
/// platform subscription itself.

@ProviderFor(TrackingController)
final trackingControllerProvider = TrackingControllerProvider._();

/// Starts and stops tracking sessions and builds the live route.
///
/// It is kept alive for the whole app run, so a session continues while
/// the user visits other screens, the app is locked or minimised. It gets
/// positions from the shared `PositionStreamService` and never opens a
/// platform subscription itself.
final class TrackingControllerProvider
    extends $NotifierProvider<TrackingController, TrackingState> {
  /// Starts and stops tracking sessions and builds the live route.
  ///
  /// It is kept alive for the whole app run, so a session continues while
  /// the user visits other screens, the app is locked or minimised. It gets
  /// positions from the shared `PositionStreamService` and never opens a
  /// platform subscription itself.
  TrackingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackingControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackingControllerHash();

  @$internal
  @override
  TrackingController create() => TrackingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackingState>(value),
    );
  }
}

String _$trackingControllerHash() =>
    r'1c1378b4cf2fd95ef9cbd3bccf2cd6ac9545a2c4';

/// Starts and stops tracking sessions and builds the live route.
///
/// It is kept alive for the whole app run, so a session continues while
/// the user visits other screens, the app is locked or minimised. It gets
/// positions from the shared `PositionStreamService` and never opens a
/// platform subscription itself.

abstract class _$TrackingController extends $Notifier<TrackingState> {
  TrackingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TrackingState, TrackingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrackingState, TrackingState>,
              TrackingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
