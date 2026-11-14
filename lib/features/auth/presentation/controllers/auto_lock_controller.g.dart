// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_lock_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Connects the [AutoLockManager] to the app: lifecycle events in, lock
/// commands out. Watched once by the root widget so it lives as long as
/// the app does.

@ProviderFor(autoLock)
final autoLockProvider = AutoLockProvider._();

/// Connects the [AutoLockManager] to the app: lifecycle events in, lock
/// commands out. Watched once by the root widget so it lives as long as
/// the app does.

final class AutoLockProvider
    extends
        $FunctionalProvider<AutoLockManager, AutoLockManager, AutoLockManager>
    with $Provider<AutoLockManager> {
  /// Connects the [AutoLockManager] to the app: lifecycle events in, lock
  /// commands out. Watched once by the root widget so it lives as long as
  /// the app does.
  AutoLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoLockHash();

  @$internal
  @override
  $ProviderElement<AutoLockManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AutoLockManager create(Ref ref) {
    return autoLock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutoLockManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutoLockManager>(value),
    );
  }
}

String _$autoLockHash() => r'57912727244ae903758b4a1df52ee2092a0dbc78';
