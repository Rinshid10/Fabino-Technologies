// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_boxes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in `main()` with the boxes opened during bootstrap.

@ProviderFor(hiveBoxes)
final hiveBoxesProvider = HiveBoxesProvider._();

/// Overridden in `main()` with the boxes opened during bootstrap.

final class HiveBoxesProvider
    extends $FunctionalProvider<HiveBoxes, HiveBoxes, HiveBoxes>
    with $Provider<HiveBoxes> {
  /// Overridden in `main()` with the boxes opened during bootstrap.
  HiveBoxesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveBoxesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveBoxesHash();

  @$internal
  @override
  $ProviderElement<HiveBoxes> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HiveBoxes create(Ref ref) {
    return hiveBoxes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveBoxes value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveBoxes>(value),
    );
  }
}

String _$hiveBoxesHash() => r'46d8777e9d256ecbf79cb398012718a0666a85db';
