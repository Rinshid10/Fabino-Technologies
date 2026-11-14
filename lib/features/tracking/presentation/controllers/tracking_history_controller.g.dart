// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Completed sessions, newest first.

@ProviderFor(TrackingHistory)
final trackingHistoryProvider = TrackingHistoryProvider._();

/// Completed sessions, newest first.
final class TrackingHistoryProvider
    extends $AsyncNotifierProvider<TrackingHistory, List<TrackingSession>> {
  /// Completed sessions, newest first.
  TrackingHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackingHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackingHistoryHash();

  @$internal
  @override
  TrackingHistory create() => TrackingHistory();
}

String _$trackingHistoryHash() => r'4bdb02f88a437430450b999a67da4bbb2070c92e';

/// Completed sessions, newest first.

abstract class _$TrackingHistory extends $AsyncNotifier<List<TrackingSession>> {
  FutureOr<List<TrackingSession>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<TrackingSession>>, List<TrackingSession>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<TrackingSession>>,
                List<TrackingSession>
              >,
              AsyncValue<List<TrackingSession>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// One session by id, or `null` when it no longer exists.

@ProviderFor(sessionDetail)
final sessionDetailProvider = SessionDetailFamily._();

/// One session by id, or `null` when it no longer exists.

final class SessionDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<TrackingSession?>,
          TrackingSession?,
          FutureOr<TrackingSession?>
        >
    with $FutureModifier<TrackingSession?>, $FutureProvider<TrackingSession?> {
  /// One session by id, or `null` when it no longer exists.
  SessionDetailProvider._({
    required SessionDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionDetailHash();

  @override
  String toString() {
    return r'sessionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TrackingSession?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TrackingSession?> create(Ref ref) {
    final argument = this.argument as String;
    return sessionDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionDetailHash() => r'4e2bd7c687c7d227f0d269645451507fb27dea5a';

/// One session by id, or `null` when it no longer exists.

final class SessionDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TrackingSession?>, String> {
  SessionDetailFamily._()
    : super(
        retry: null,
        name: r'sessionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One session by id, or `null` when it no longer exists.

  SessionDetailProvider call(String id) =>
      SessionDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'sessionDetailProvider';
}
