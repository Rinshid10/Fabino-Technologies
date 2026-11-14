// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'bc94bf789cfc0efc965f30ea769ae1531e26c41d';

/// Last successful authentication and wrong-PIN counters.

@ProviderFor(authStatus)
final authStatusProvider = AuthStatusProvider._();

/// Last successful authentication and wrong-PIN counters.

final class AuthStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthStatus>,
          AuthStatus,
          FutureOr<AuthStatus>
        >
    with $FutureModifier<AuthStatus>, $FutureProvider<AuthStatus> {
  /// Last successful authentication and wrong-PIN counters.
  AuthStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStatusHash();

  @$internal
  @override
  $FutureProviderElement<AuthStatus> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthStatus> create(Ref ref) {
    return authStatus(ref);
  }
}

String _$authStatusHash() => r'c99d0da904977522fee91f8de73271da9a3a151f';

/// Biometric hardware and enrolment on this device.

@ProviderFor(biometricStatus)
final biometricStatusProvider = BiometricStatusProvider._();

/// Biometric hardware and enrolment on this device.

final class BiometricStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<BiometricStatus>,
          BiometricStatus,
          FutureOr<BiometricStatus>
        >
    with $FutureModifier<BiometricStatus>, $FutureProvider<BiometricStatus> {
  /// Biometric hardware and enrolment on this device.
  BiometricStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricStatusHash();

  @$internal
  @override
  $FutureProviderElement<BiometricStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BiometricStatus> create(Ref ref) {
    return biometricStatus(ref);
  }
}

String _$biometricStatusHash() => r'6356d53f835a614484c778a04984708460cb72a4';

@ProviderFor(authController)
final authControllerProvider = AuthControllerProvider._();

final class AuthControllerProvider
    extends $FunctionalProvider<AuthController, AuthController, AuthController>
    with $Provider<AuthController> {
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  $ProviderElement<AuthController> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthController create(Ref ref) {
    return authController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthController>(value),
    );
  }
}

String _$authControllerHash() => r'c77eb1828a78365ed6790199acc0575d7a55cd06';
