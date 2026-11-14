// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether a PIN already existed when the app started.
/// Overridden in `bootstrap()`.

@ProviderFor(pinConfiguredAtStartup)
final pinConfiguredAtStartupProvider = PinConfiguredAtStartupProvider._();

/// Whether a PIN already existed when the app started.
/// Overridden in `bootstrap()`.

final class PinConfiguredAtStartupProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether a PIN already existed when the app started.
  /// Overridden in `bootstrap()`.
  PinConfiguredAtStartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinConfiguredAtStartupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinConfiguredAtStartupHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return pinConfiguredAtStartup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pinConfiguredAtStartupHash() =>
    r'4c4589239b0a9da09c9a3aab78635f00572d320a';

/// The single source of truth for the lock state. The router redirects to
/// the lock screen whenever this is not [AppLockState.unlocked].

@ProviderFor(AppLock)
final appLockProvider = AppLockProvider._();

/// The single source of truth for the lock state. The router redirects to
/// the lock screen whenever this is not [AppLockState.unlocked].
final class AppLockProvider extends $NotifierProvider<AppLock, AppLockState> {
  /// The single source of truth for the lock state. The router redirects to
  /// the lock screen whenever this is not [AppLockState.unlocked].
  AppLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockHash();

  @$internal
  @override
  AppLock create() => AppLock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLockState>(value),
    );
  }
}

String _$appLockHash() => r'43d1d54ab2dbcfdf884a833d598cb09baea0f5a4';

/// The single source of truth for the lock state. The router redirects to
/// the lock screen whenever this is not [AppLockState.unlocked].

abstract class _$AppLock extends $Notifier<AppLockState> {
  AppLockState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppLockState, AppLockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLockState, AppLockState>,
              AppLockState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
