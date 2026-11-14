// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_status_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authStatusRepository)
final authStatusRepositoryProvider = AuthStatusRepositoryProvider._();

final class AuthStatusRepositoryProvider
    extends
        $FunctionalProvider<
          AuthStatusRepository,
          AuthStatusRepository,
          AuthStatusRepository
        >
    with $Provider<AuthStatusRepository> {
  AuthStatusRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStatusRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStatusRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthStatusRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthStatusRepository create(Ref ref) {
    return authStatusRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStatusRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStatusRepository>(value),
    );
  }
}

String _$authStatusRepositoryHash() =>
    r'759b3634d8c06a8a7761fde1dc5e1a45022d9a29';
