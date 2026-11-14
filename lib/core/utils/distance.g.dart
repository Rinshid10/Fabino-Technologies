// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(distanceCalculator)
final distanceCalculatorProvider = DistanceCalculatorProvider._();

final class DistanceCalculatorProvider
    extends
        $FunctionalProvider<
          DistanceCalculator,
          DistanceCalculator,
          DistanceCalculator
        >
    with $Provider<DistanceCalculator> {
  DistanceCalculatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distanceCalculatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distanceCalculatorHash();

  @$internal
  @override
  $ProviderElement<DistanceCalculator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DistanceCalculator create(Ref ref) {
    return distanceCalculator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DistanceCalculator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DistanceCalculator>(value),
    );
  }
}

String _$distanceCalculatorHash() =>
    r'1a4e5897896222c4bc3025b02e6b3bcf17bb901b';
