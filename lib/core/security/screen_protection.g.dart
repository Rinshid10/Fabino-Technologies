// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_protection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(screenProtector)
final screenProtectorProvider = ScreenProtectorProvider._();

final class ScreenProtectorProvider
    extends
        $FunctionalProvider<ScreenProtector, ScreenProtector, ScreenProtector>
    with $Provider<ScreenProtector> {
  ScreenProtectorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenProtectorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenProtectorHash();

  @$internal
  @override
  $ProviderElement<ScreenProtector> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScreenProtector create(Ref ref) {
    return screenProtector(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenProtector value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenProtector>(value),
    );
  }
}

String _$screenProtectorHash() => r'6493e35faadc26df75a4407ecb1ddd0fcd62bf63';

/// Keeps the platform protection in sync with the user's setting.
///
/// Protection covers the whole app, which includes the lock screen, the
/// PIN screens and the dashboard. The root widget watches this provider
/// once.

@ProviderFor(screenProtection)
final screenProtectionProvider = ScreenProtectionProvider._();

/// Keeps the platform protection in sync with the user's setting.
///
/// Protection covers the whole app, which includes the lock screen, the
/// PIN screens and the dashboard. The root widget watches this provider
/// once.

final class ScreenProtectionProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Keeps the platform protection in sync with the user's setting.
  ///
  /// Protection covers the whole app, which includes the lock screen, the
  /// PIN screens and the dashboard. The root widget watches this provider
  /// once.
  ScreenProtectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenProtectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenProtectionHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return screenProtection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$screenProtectionHash() => r'47c38c0ca1a6d664b5ea0941ddc30150ae96ab6f';
