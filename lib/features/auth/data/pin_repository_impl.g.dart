// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pinHasher)
final pinHasherProvider = PinHasherProvider._();

final class PinHasherProvider
    extends $FunctionalProvider<PinHasher, PinHasher, PinHasher>
    with $Provider<PinHasher> {
  PinHasherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinHasherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinHasherHash();

  @$internal
  @override
  $ProviderElement<PinHasher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinHasher create(Ref ref) {
    return pinHasher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinHasher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinHasher>(value),
    );
  }
}

String _$pinHasherHash() => r'bf123b7a94382d6d9c983eb13e266568a7ea19f5';

@ProviderFor(pinRepository)
final pinRepositoryProvider = PinRepositoryProvider._();

final class PinRepositoryProvider
    extends $FunctionalProvider<PinRepository, PinRepository, PinRepository>
    with $Provider<PinRepository> {
  PinRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinRepositoryHash();

  @$internal
  @override
  $ProviderElement<PinRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinRepository create(Ref ref) {
    return pinRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinRepository>(value),
    );
  }
}

String _$pinRepositoryHash() => r'de2035bbdb576fbf29cd7046fd8c0807afd3c9ec';
