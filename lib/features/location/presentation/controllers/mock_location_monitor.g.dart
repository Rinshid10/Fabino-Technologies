// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_location_monitor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mockLocationAlert)
final mockLocationAlertProvider = MockLocationAlertProvider._();

final class MockLocationAlertProvider
    extends
        $FunctionalProvider<
          MockLocationAlert,
          MockLocationAlert,
          MockLocationAlert
        >
    with $Provider<MockLocationAlert> {
  MockLocationAlertProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockLocationAlertProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockLocationAlertHash();

  @$internal
  @override
  $ProviderElement<MockLocationAlert> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MockLocationAlert create(Ref ref) {
    return mockLocationAlert(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockLocationAlert value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockLocationAlert>(value),
    );
  }
}

String _$mockLocationAlertHash() => r'ad361cc18cf329d992e9d5e168873503ae9bd338';

/// Checks every position of the shared stream for mocking.
///
/// It only listens: it never asks for the stream to be started, so it
/// costs no battery on its own. The root widget watches this provider once
/// so the check runs for the app's whole lifetime.

@ProviderFor(mockLocationMonitor)
final mockLocationMonitorProvider = MockLocationMonitorProvider._();

/// Checks every position of the shared stream for mocking.
///
/// It only listens: it never asks for the stream to be started, so it
/// costs no battery on its own. The root widget watches this provider once
/// so the check runs for the app's whole lifetime.

final class MockLocationMonitorProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Checks every position of the shared stream for mocking.
  ///
  /// It only listens: it never asks for the stream to be started, so it
  /// costs no battery on its own. The root widget watches this provider once
  /// so the check runs for the app's whole lifetime.
  MockLocationMonitorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockLocationMonitorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockLocationMonitorHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return mockLocationMonitor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mockLocationMonitorHash() =>
    r'922a1a234f028b24c2c288979509b3be5a0aa0e7';
