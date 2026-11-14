// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether past tracking routes are drawn on the map.

@ProviderFor(PastRoutesVisible)
final pastRoutesVisibleProvider = PastRoutesVisibleProvider._();

/// Whether past tracking routes are drawn on the map.
final class PastRoutesVisibleProvider
    extends $NotifierProvider<PastRoutesVisible, bool> {
  /// Whether past tracking routes are drawn on the map.
  PastRoutesVisibleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pastRoutesVisibleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pastRoutesVisibleHash();

  @$internal
  @override
  PastRoutesVisible create() => PastRoutesVisible();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pastRoutesVisibleHash() => r'b496ab8e419ce68da861a967c0fc106c1d1509da';

/// Whether past tracking routes are drawn on the map.

abstract class _$PastRoutesVisible extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
